#!/usr/bin/env python
import os, sys

# cmd parsing
if len(sys.argv)>1 and os.path.isfile(sys.argv[1]): file=sys.argv[1]
else: print "Usage: upload.py <file>"; sys.exit()

# can be overridden by environment variables
mode='scp'
server=''
user=''
remote_root=''
local_root=''

# override defaults with environment variables
if os.getenv('UPLOAD_MODE'): mode = os.getenv('UPLOAD_MODE')
if os.getenv('UPLOAD_SERVER'): server = os.getenv('UPLOAD_SERVER')
if os.getenv('UPLOAD_USER'): user = os.getenv('UPLOAD_USER')
if os.getenv('UPLOAD_REMOTE_ROOT'): remote_root = os.getenv('UPLOAD_REMOTE_ROOT')
if os.getenv('UPLOAD_LOCAL_ROOT'): local_root = os.getenv('UPLOAD_LOCAL_ROOT')

# add other modes here
if mode=='scp':
  if not os.getcwd().startswith(local_root): print 'file not in %s'%local_root; sys.exit()
  else: ext_path=os.path.join(os.getcwd().replace(local_root, remote_root), file)
  cmd = 'scp %s %s@%s:%s'%(file, user, server, ext_path)
  failure = os.system(cmd)
  if failure: print "Running %s failed..."%cmd
