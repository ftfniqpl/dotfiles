
" 配置文件名
if !exists('g:sftp_sync')
  let g:sftp_sync = './.vim_sftp'
endif

" 判断当前路径存不存在 rc 配置文件
"if filereadable(g:sftp_sync)
"  let s_hasConf = 1
"else
"  let s_hasConf = 0
"endif

" 服务器同步需要的配置信息
"let s_conf = {}

" 获取默认配置
function GetConf()
  if expand('%:t') == fnamemodify(g:sftp_sync, ':p:t')
    return
  endif
  if filereadable(g:sftp_sync)
    let conf = eval(join(readfile(g:sftp_sync)))
  else
    let conf = {}
    let conf['host'] = input('host? ')
    let conf['port'] = input('port? ', '22')
    let conf['user'] = input('user? ', 'root')
    let conf['pass'] = inputsecret('pass? ', '')
    let conf['remote'] = input('remote_path? ', '')
    call writefile(split(string(conf), "\n"), g:sftp_sync)
  endif
  return conf
endfunction

" 上传主函数
function UploadSyncFile()
  let l_currentPath = expand('%')
  let conf = GetConf()
  let conf['local'] = fnamemodify(g:sftp_sync, ':h:p') . '/'
  let conf['localpath'] = l_currentPath
  let conf['remotepath'] = conf['remote'] . conf['localpath'][strlen(conf['local']):]

  " 若当前文件不可读，直接返回
  if !filereadable(l_currentPath)
    echo 'current path not readable !'
    return
  endif

  let action = printf('put %s %s', conf['localpath'], conf['remotepath'])
  let cmd = printf('expect -c "set timeout 5; spawn sftp -P %s %s@%s; expect \"*assword:\"; send %s\r; expect \"sftp>\"; send \" %s\r\"; expect -re \"100%\"; send \"exit\r\";"', conf['port'], conf['user'], conf['host'], conf['pass'], action)
  if conf['confirm_upload'] == 1
    let choice = confirm('Upload file?', "&Yes\n&No", 2)
    if choice != 1
      echo 'Canceled.'
      return
    endif
  endif

  execute '!' . cmd
endfunction

function! DownloadSyncFile()
  let l_currentPath = expand('%')
  let conf = GetConf()
  let conf['local'] = fnamemodify(g:sftp_sync, ':h:p') . '/'
  let conf['localpath'] = l_currentPath
  let conf['remotepath'] = conf['remote'] . conf['localpath'][strlen(conf['local']):]

  let action = printf('get %s %s', conf['remotepath'], conf['localpath'])
  let cmd = printf('expect -c "set timeout 5; spawn sftp -P %s %s@%s; expect \"*assword:\"; send %s\r; expect \"sftp>\"; send \" %s\r\"; expect -re \"100%\"; send \"exit\r\";"', conf['port'], conf['user'], conf['host'], conf['pass'], action)

  if conf['confirm_download'] == 1
    let choice = confirm('Download file?', "&Yes\n&No", 2)
    if choice != 1
      echo 'Canceled.'
      return
    endif
  endif

  execute '!' . cmd
endfunction

function! UploadSyncFolder()
  let l_currentPath = expand('%')
  let conf = GetConf()
  let conf['local'] = fnamemodify(g:sftp_sync, ':h:p') . '/'
  let conf['localpath'] = l_currentPath
  let conf['remotepath'] = conf['remote'] . conf['localpath'][strlen(conf['local']):]

  let action = "send pwd\r;"
  for file in split(glob('%:p:h/*'), '\n')
    let conf['localpath'] = file
    let conf['remotepath'] = conf['remote'] . conf['localpath'][strlen(conf['local']):]

    if conf['confirm_upload'] == 1
      let choice = confirm('Upload file?', "&Yes\n&No", 2)
      if choice != 1
        echo 'Canceled.'
        return
      endif
    endif
    let action = action . printf('expect \"sftp>\"; send \"put %s %s\r\";', conf['localpath'], conf['remotepath'])
  endfor

  let cmd = printf('expect -c "set timeout 5; spawn sftp -P %s %s@%s; expect \"*assword:\"; send %s\r; %s expect -re \"100%\"; send \"exit\r\";"', conf['port'], conf['user'], conf['host'], conf['pass'], action)

  execute '!' . cmd
endfunction

" 暴露 Command
command! UploadFile :call UploadSyncFile()
command! DownloadFile :call DownloadSyncFile()
command! UploadDir :call UploadSyncFolder()
