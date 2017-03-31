import itertools
import jedi


def flatten(text):
    return ' '.join(map(lambda x: x.strip(), text.split("\n")))


def truncate(text, length=60):
    if len(text) > length:
        return text[:length-3] + '...'
    else:
        return text


def parse_docstring(docstring):
    lines = map(lambda x: x.strip(), docstring.split("\n"))
    definitions = list(itertools.dropwhile(lambda x: x, lines))
    summaries = itertools.dropwhile(lambda x: not x, definitions)
    summaries = itertools.takewhile(lambda x: x, summaries)
    summaries = list(summaries)
    summaries = summaries if summaries else list(lines)
    return definitions, summaries


def get_script(vim, source=None, row=None, col=None):
    jedi.settings.additional_dynamic_modules = [
        b.name for b in vim.buffers if b.name and b.name.endswith('.py')
    ]
    if source is None:
        source = "\n".join(vim.current.buffer)
    if row is None:
        row = vim.current.window.cursor[0]
    if col is None:
        col = vim.current.window.cursor[1]
    return jedi.Script(
        source, row, col,
        path=vim.current.buffer.name,
        encoding=vim.eval('&encoding') or 'latin1',
    )
