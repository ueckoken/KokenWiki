import {CHANGE_TEXT,ONCLICK_EDIT,ONCLICK_CANCEL,SET_CONTENT, CHANGE_READABLE_GROUP, CHANGE_EDITABLE_GROUP, ONCLICK_IS_PUBLIC, ONCLICK_IS_DRAFT} from "./action_name"
const initialState = {
    markdown: "",
    default_markdown: "",
    usergroups: [],
    is_edit: false,
    is_changed: false,
    is_editable: false,
    readable_group_id: 0,
    editable_group_id: 0,
    default_readable_group_id: 0,
    default_editable_group_id: 0,
    default_is_draft: false,
    default_is_public: false,
    is_draft: false,
    is_public: false,
};
const MdEditorReducer = (state = initialState, action) => {
    switch (action.type) {
        case CHANGE_TEXT:
            if(state.is_editable == false){
                return state;
            }
            return Object.assign({}, state, {
                markdown: action.payload.text,
                is_changed: true,
                textHeight: action.payload.textHeight + "px"
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
                is_edit: false,
                is_changed: false,
                readable_group_id: state.default_readable_group_id,
                editable_group_id: state.default_editable_group_id,
                is_draft: state.default_is_draft,
                is_public: state.default_is_public
            });
        case ONCLICK_IS_DRAFT:
            if(state.is_editable == false){
                return state;
            }
            return Object.assign({}, state, {
                is_draft: !state.is_draft,
                is_changed: true
            });
        
        case ONCLICK_IS_PUBLIC:
            if(state.is_editable == false){
                return state;
            }
            return Object.assign({}, state, {
                is_public: !state.is_public,
                is_changed: true
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
                default_is_draft: action.payload.default_is_draft,
                default_is_public: action.payload.default_is_public,
                is_draft: action.payload.default_is_draft,
                is_public: action.payload.default_is_public,
                is_edit: false
            });
        default:
            return state;
    }
};
export default MdEditorReducer;