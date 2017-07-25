import commands

def get_password(account_name):
    cmd = "security find-generic-password -s %s_email -w" % account_name
    (status,output) = commands.getstatusoutput(cmd)
    return output
