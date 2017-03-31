import neovim


@neovim.plugin
class RediEntryPoint:
    def __init__(self, vim):
        import os
        import sys
        self.vim = vim

        module_path = os.path.normpath(os.path.join(
            os.path.dirname(__file__),
            '../../pythonx',
        ))
        if module_path not in sys.path:
            sys.path.insert(0, module_path)

    @neovim.function('_redi_completion_gather_candidates_py3', sync=True)
    def completion_gather_candidates(self, args):
        from redi import completion_gather_candidates as gather_candidates
        return gather_candidates(self.vim, args)

    @neovim.function('_redi_signature_gather_candidates_py3', sync=True)
    def signature_gather_candidates(self, args):
        from redi import signature_gather_candidates as gather_candidates
        return gather_candidates(self.vim, args)
