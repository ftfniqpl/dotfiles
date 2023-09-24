import os
import vim
import paramiko
import json

SftpCache = {}

# 判断 当前目录 是否有 sftp.json 文件
def _load_config():
    ''' Find the sftp config file '''
    file_name = vim.current.buffer.name
    cur_dir = os.path.dirname(file_name)
    config_file = ''
    find_config_file = False
    # 先从当前文件的目录往上找 .sftp文件, 如果找到则停止
    while cur_dir:
        config_file = f"{cur_dir}/.sftp"
        if os.path.isfile(config_file):
            find_config_file = True
            break
        if cur_dir == '/':
            break
        cur_dir = os.path.dirname(cur_dir)

    if find_config_file:
        #plugin_root_dir = vim.eval('s:plugin_root_dir')
        #config_file = os.path.join(plugin_root_dir, '..', 'sftp.json')
        try:
            with open(config_file, 'r') as cfile:
                config = json.load(cfile)
            return config_file, config
        except:
            return None, None
    return None, None

def connect(config):
    ''' 根据 config 信息建立连接并缓存起来。'''
    # get host key, if we know one
    try:
        host_keys = paramiko.util.load_host_keys(
            os.path.expanduser("~/.ssh/known_hosts")
        )
    except IOError:
        try:
            host_keys = paramiko.util.load_host_keys(
                os.path.expanduser("~/ssh/known_hosts")
            )
        except IOError:
            print("*** Unable to open host keys file ***")
            host_keys = {}

    host = config.get("host")
    user = config.get("user")
    port = config.get("port")
    password = config.get("password")
    remote_path = config.get("remote_path")

    hostkeytype = None
    hostkey = None
    if host in host_keys:
        hostkeytype = host_keys[host].keys()[0]
        hostkey = host_keys[host][hostkeytype]
        print("Using host key of type %s " % hostkeytype)

    # now, connect and use paramiko Transport to negotiate SSH2
    # accross the connection.
    try:
        t = paramiko.Transport((host, int(port)))
        t.connect(
            hostkey,
            user,
            password,
            # gss_host=socket.getfqdn(host),
            # gss_auth=UseGSSAPI,
            # gss_kex=DoGSSAPIKeyExchange,
        )
        sftp = paramiko.SFTPClient.from_transport(t)
        config_file = config.get('config_file')

        SftpCache[config_file] = {
            'conn': sftp,
            'remote_path': remote_path
        }
        # create observer
        vim.command("echom 'connection succeed!'")
        return SftpCache[config_file]

    except Exception as e:
        print("*** Caught exception: %s:%s " % (e.__class__, e))
        return None

def mkdir_p(sftp, remote_directory):
    """Change to this directory, recursively making new folders if needed.
        Returns True if any folders were created.
    """
    if remote_directory == '/':
        # absolute path so change directory to root
        sftp.chdir('/')
        return
    if remote_directory == '':
        # top-level relative directory must exist
        return
    try:
        sftp.chdir(remote_directory) # sub-directory exists
    except IOError:
        dirname, basename = os.path.split(remote_directory.rstrip('/'))
        mkdir_p(sftp, dirname) # make parent directories
        sftp.mkdir(basename) # sub-directory missing, so created it
        sftp.chdir(basename)
        return True

def sftp_put(file_name, config_file, config):
    #config_file, config = _load_config()
    #if config_file:
    #    config['config_file'] = config_file
    sftp = SftpCache.get(config_file)

    if sftp is None:
        sftp = connect(config)
    else:
        print('already connected')

    if sftp is None:
        print('SFTP connect failed! ')
        return

    # config_dir = os.path.dirname(config_file)
    # new_file_name = file_name.replace(config['project_path'], '')
    remote_file = sftp['remote_path'] + file_name.replace(config['project_path'], '')
    remote_dir = os.path.dirname(remote_file)
    # print(remote_file, '....remote_file....', remote_dir, '...remote_dir....')
    conn = sftp.get('conn')
    try:
        conn.chdir(remote_dir)  # Test if remote_path exists
    except:
        print('change dir success')
        mkdir_p(conn, remote_dir)
        conn.chdir(remote_dir)
    try:
        conn.put(file_name, remote_file)
    except Exception as e:
        print(e)
        vim.command("echom 'upload failed!'")
    return None

all_files = []
def get_files(path):
    lsdir = os.listdir(path)
    dirs = [i for i in lsdir if os.path.isdir(os.path.join(path, i))]
    files = [i for i in lsdir if os.path.isfile(os.path.join(path, i))]
    if files:
        for f in files:
            if f.startswith('.'):
                continue
            _, ext = os.path.splitext(f)
            if ext in ['.swp']:
                continue
            all_files.append(os.path.join(path, f))
    if dirs:
        for d in dirs:
            get_files(os.path.join(path, d))

def sftp_file():
    file_name = vim.current.buffer.name
    config_file, config = _load_config()
    if config_file:
        config['config_file'] = config_file
        sftp_put(file_name, config_file, config)
        vim.command("echo 'upload succeed!'")
    vim.command("echom 'not found .sftp file and exit.'")

def sftp_folder():
    # 上传当前目录的所有文件
    file_name = vim.current.buffer.name
    _folder, _file = os.path.split(file_name)
    get_files(_folder)
    config_file, config = _load_config()
    if config_file:
        config['config_file'] = config_file
        for f in all_files:
            sftp_put(f, config_file, config)
        vim.command("echo 'upload folder succeed!'")
    vim.command("echom 'not found .sftp file and exit.'")

def sftp_clear():
    if SftpCache:
        vim.command("echom 'clear the sftp connection'")
        for _, item in SftpCache.items():
            item.get('conn').close()
        vim.command("sleep 10m")
    return None
