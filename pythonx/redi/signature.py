from .util import (
    truncate,
    get_script,
    parse_docstring,
)


class Signature:
    def __init__(self, vim):
        self.vim = vim
        self.description_max_length = vim.vars.get(
            'redi#signature#description_max_length', 80
        )

    def gather_candidates(self):
        script = get_script(self.vim)
        try:
            signatures = script.call_signatures()
            candidates = [
                _parse_signature(s, self.description_max_length)
                for s in signatures
            ]
            return candidates
        except AttributeError:
            # No signature is available
            return []
        except Exception as e:
            from redi.console import echoerr
            echoerr(self.vim, str(e))
            return []


def _parse_signature(signature, description_max_length):
    params = [p.description.replace("\n", ' ')
              for p in signature.params]
    definitions, summaries = parse_docstring(signature.docstring() or '')

    def join_params():
        return ', '.join(filter(lambda x: x, [
            params_ltext,
            params_ctext,
            params_rtext,
        ]))

    if signature.index is not None:
        index = signature.index
        params_ltext = ', '.join(params[:index])
        params_ctext = params[index]
        params_rtext = ', '.join(params[index+1:])
        if params_rtext and params_ctext:
            params_ctext += ', '
        if params_ctext and params_ltext:
            params_ltext += ', '
    else:
        params_ltext = ''
        params_ctext = ''
        params_rtext = ', '.join(params)
    params_text = ', '.join(filter(lambda x: x, [
        params_ltext,
        params_ctext,
        params_rtext,
    ]))
    params = dict(
        index=-1 if signature.index is None else signature.index,
        call_name=signature.call_name,
        description=truncate(' '.join(summaries), description_max_length),
        params=params,
        params_text=params_text,
        params_ltext=params_ltext,
        params_ctext=params_ctext,
        params_rtext=params_rtext,
    )
    return params
