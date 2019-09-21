import Actions from "./Actions"
export const mapStateToProps = (state) => {
    return {
        markdown: state.markdown,
        tabIndex: state.tabIndex,
        is_edit: state.is_edit,
        is_changed: state.is_changed,
    }
};
export const mapDispatchToProps = (dispatch) => {
    return {
        handleChangeTab: (index, last) => dispatch(Actions.changeTab(index, last)),
        handleChangeText: (e) => dispatch(Actions.changeText(e)),
        handleOnClickEdit: (e) => dispatch(Actions.onClickEdit(e)),
        handleOnClickCancel: (e) => dispatch(Actions.onClickCancel(e)),
        handleSetContent: (content) => dispatch(Actions.setContent(content)),
    }
};