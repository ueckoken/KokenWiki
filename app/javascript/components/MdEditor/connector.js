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
        default_readable_group_id: state.default_readable_group_id,
        default_editable_group_id: state.default_editable_group_id,
    }
};
export const mapDispatchToProps = (dispatch) => {
    return {
        handleChangeTab: (index, last) => dispatch(Actions.changeTab(index, last)),
        handleChangeText: (e) => dispatch(Actions.changeText(e)),
        handleOnClickEdit: (e) => dispatch(Actions.onClickEdit(e)),
        handleOnClickCancel: (e) => dispatch(Actions.onClickCancel(e)),
        handleSetContent: (content,usergroups,is_editable,readable_group_id,editable_group_id) => dispatch(Actions.setContent(content,usergroups,is_editable,readable_group_id,editable_group_id)),
        handleChangeReadableGroup: (e) => dispatch(Actions.changeReadableGroup(e)),
        handleChangeEditableGroup: (e) => dispatch(Actions.changeEditableGroup(e)),
    }
};