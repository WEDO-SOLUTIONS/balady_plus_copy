/// Outcome of resolving a scanned or opened invite token (S-09: R-29,
/// R-33-35). [invalidOrBlocked] deliberately covers three distinct BRD
/// cases (unknown token, reset token, blocked owner) with one message —
/// R-33 requires them to be indistinguishable so a link holder can't probe
/// another user's block state.
enum InviteResolution { success, invalidOrBlocked, selfRequest }
