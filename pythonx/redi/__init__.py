def completion_gather_candidates(vim, args):
    try:
        from redi.completion import Completion
        completion = Completion(vim)
        return completion.gather_candidates()
    except Exception as e:
        from redi.console import echoerr
        echoerr(vim, str(e))


def signature_gather_candidates(vim, args):
    try:
        from redi.signature import Signature
        signature = Signature(vim)
        return signature.gather_candidates()
    except Exception as e:
        from redi.console import echoerr
        echoerr(vim, str(e))
