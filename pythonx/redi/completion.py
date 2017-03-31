from .util import (
    flatten,
    truncate,
    get_script,
    parse_docstring,
)


class Completion:
    def __init__(self, vim):
        self.vim = vim
        self.menu_max_length = vim.vars.get(
            'redi#completion#menu_max_length', 80
        )
        self.type_indicators = vim.vars.get(
            'redi#completion#type_indicators', {
                'class':    '[c] ',
                'instance': '[i] ',
                'function': '[f] ',
                'module':   '[m] ',
                'keyword':  '[k] ',
                'other':    '    ',
            },
        )

    def gather_candidates(self, base=''):
        vim = self.vim
        row, col = vim.current.window.cursor
        source = []
        for i, line in enumerate(vim.current.buffer):
            if i + 1 == row:
                source.append(line[:col] + base + line[col:])
            else:
                source.append(line)
        source = "\n".join(source)
        script = get_script(vim, source, row, col+len(base))
        completions = script.completions()
        candidates = [
            _parse_completion(c, self.menu_max_length, self.type_indicators)
            for c in completions
        ]
        return candidates


def _parse_completion(completion, menu_max_length, type_indicators):
    type_ = completion.description.split(':')[0]
    indicator = type_indicators.get(type_, '')

    docstring = completion.docstring() or None
    if docstring:
        definitions, summaries = parse_docstring(docstring)
        menu = ' '.join(summaries)
        info = docstring
    else:
        menu = flatten(completion.description.replace('%s:' % type_, ''))
        info = completion.description

    params = dict(
        word=completion.complete,
        abbr=completion.name,
        menu='%s%s' % (indicator, truncate(menu, menu_max_length)),
        info=info,
        icase=1,
    )
    return params
