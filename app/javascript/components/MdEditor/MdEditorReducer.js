import {CHANGE_TAB,CHANGE_TEXT,ONCLICK_EDIT,ONCLICK_CANCEL,SET_CONTENT} from "./action_name"
const initialState = {
    markdown: "",
    default_markdown: "",
    tabIndex: 1,
    is_edit: false,
    is_changed: false,
};
const MdEditorReducer = (state = initialState, action) => {
    switch (action.type) {
        case CHANGE_TAB:
            return Object.assign({}, state, {
                tabIndex: action.payload.tabIndex,
            });
        case CHANGE_TEXT:
            return Object.assign({}, state, {
                markdown: action.payload.text,
                is_changed: true
            });

        case ONCLICK_EDIT:
            return Object.assign({}, state, {
                is_edit: true
            });

        case ONCLICK_CANCEL:
            return Object.assign({}, state, {
                markdown: state.default_markdown,
                tabIndex: 0,
                is_edit: false,
                is_changed: false,
            });
        case SET_CONTENT:
            return Object.assign({}, state, {
                markdown: action.payload.markdown,
                default_markdown: action.payload.markdown,
            });
        default:
            return state;
    }
};
export default MdEditorReducer;