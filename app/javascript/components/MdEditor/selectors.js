export const isChangedSelector = state => (
    state.markdown !== state.default_markdown ||
    state.readable_group_id !== state.default_readable_group_id ||
    state.editable_group_id !== state.default_editable_group_id ||
    state.is_draft !== state.default_is_draft ||
    state.is_public !== state.default_is_public
);
