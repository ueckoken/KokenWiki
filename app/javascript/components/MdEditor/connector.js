import Actions from "./Actions"
export const mapStateToProps = (state) => {
    return {
        markdown: state.markdown,
        usergroups: state.usergroups,
        tabIndex: state.tabIndex,
        is_edit: state.is_edit,
        is_changed: state.is_changed,
        is_editable: state.is_editable,
        readable_group_id: state.readable_group_id,
        editable_group_id: state.editable_group_id,
        is_draft: state.is_draft,
        is_public: state.is_public,
    }
};
export const mapDispatchToProps = (dispatch) => {
    return {
        handleChangeTab: (index, last) => dispatch(Actions.changeTab(index, last)),
        handleChangeText: (e) => dispatch(Actions.changeText(e)),
        handleOnClickEdit: (e) => dispatch(Actions.onClickEdit(e)),
        handleOnClickCancel: (e) => dispatch(Actions.onClickCancel(e)),
        handleOnClickIsDraft: (e) => dispatch(Actions.onClickIsDraft(e)),
        handleOnClickIsPublic: (e) => dispatch(Actions.onClickIsPublic(e)),
        handleSetContent: (content,usergroups,is_editable,readable_group_id,editable_group_id,is_draft,is_public) => dispatch(Actions.setContent(content,usergroups,is_editable,readable_group_id,editable_group_id,is_draft,is_public)),
        handleChangeReadableGroup: (e) => dispatch(Actions.changeReadableGroup(e)),
        handleChangeEditableGroup: (e) => dispatch(Actions.changeEditableGroup(e)),
    }
};