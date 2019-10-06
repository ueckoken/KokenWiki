import {CHANGE_TAB,CHANGE_TEXT,ONCLICK_EDIT,ONCLICK_CANCEL,SET_CONTENT, CHANGE_READABLE_GROUP, CHANGE_EDITABLE_GROUP} from "./action_name"
const initialState = {
    markdown: "",
    default_markdown: "",
    usergroups: [],
    tabIndex: 1,
    is_edit: false,
    is_changed: false,
    is_editable: false,
    readable_group_id: 0,
    editable_group_id: 0,
    default_readable_group_id: 0,
    default_editable_group_id: 0,
};
const MdEditorReducer = (state = initialState, action) => {
    switch (action.type) {
        case CHANGE_TAB:
            if(state.is_editable == false){
                return state;
            }
            return Object.assign({}, state, {
                tabIndex: action.payload.tabIndex,
            });
        case CHANGE_TEXT:
            if(state.is_editable == false){
                return state;
            }
            return Object.assign({}, state, {
                markdown: action.payload.text,
                is_changed: true
            });
            case CHANGE_READABLE_GROUP:
                if(state.is_editable == false){
                    return state;
                }
                return Object.assign({}, state, {
                    readable_group_id: action.payload.readable_group_id,
                    is_changed: true
                });
            case CHANGE_EDITABLE_GROUP:
                if(state.is_editable == false){
                    return state;
                }
                return Object.assign({}, state, {
                    editable_group_id: action.payload.editable_group_id,
                    is_changed: true
                });

        case ONCLICK_EDIT:
            if(state.is_editable == false){
                return state;
            }
            return Object.assign({}, state, {
                is_edit: true
            });

        case ONCLICK_CANCEL:
            return Object.assign({}, state, {
                markdown: state.default_markdown,
                tabIndex: 0,
                is_edit: false,
                is_changed: false,
                readable_group_id: state.default_readable_group_id,
                editable_group_id: state.default_editable_group_id,
            });
        case SET_CONTENT:
            return Object.assign({}, state, {
                markdown: action.payload.markdown,
                default_markdown: action.payload.markdown,
                usergroups: action.payload.usergroups,
                is_editable: action.payload.is_editable,
                readable_group_id: action.payload.default_readable_group_id,
                editable_group_id: action.payload.default_editable_group_id,
                default_readable_group_id: action.payload.default_readable_group_id,
                default_editable_group_id: action.payload.default_editable_group_id,
            });
        default:
            return state;
    }
};
export default MdEditorReducer;