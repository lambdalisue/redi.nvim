ESCAPE_ECHO = str.maketrans({
    '"': '\\"',
    '\\': '\\\\',
})


def echomsg(vim, msg):
    """echo a newline separated message"""
    for line in msg.splitlines():
        vim.command('echomsg "%s"' % line.translate(ESCAPE_ECHO))


def echoerr(vim, msg):
    """echo a newline separated error"""
    vim.command('echohl ErrorMsg')
    echomsg(vim, msg)
    vim.command('echohl None')
