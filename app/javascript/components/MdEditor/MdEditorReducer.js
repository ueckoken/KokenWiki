import { createReducer } from "@reduxjs/toolkit";
import { changeText, changeReadableGroup, changeEditableGroup, onClickEdit, onClickCancel, onClickIsDraft, onClickIsPublic, setContent } from "./Actions";

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

const MdEditorReducer = createReducer(initialState, {
    [changeText]: (state, action) => {
        if (state.is_editable == false) {
            return state;
        }
        state.markdown = action.payload.text;
        state.is_changed = true;
        state.textHeight = action.payload.textHeight + "px";
        return state;
    },
    [changeReadableGroup]: (state, action) => {
        if (state.is_editable == false) {
            return state;
        }
        state.readable_group_id = action.payload.readable_group_id;
        state.is_changed = true;
        return state;
    },
    [changeEditableGroup]: (state, action) => {
        if (state.is_editable == false) {
            return state;
        }
        state.editable_group_id = action.payload.editable_group_id;
        state.is_changed = true;
        return state;
    },
    [onClickEdit]: state => {
        if (state.is_editable == false) {
            return state;
        }
        state.is_edit = true;
        return state;
    },
    [onClickCancel]: state => {
        state.markdown = state.default_markdown;
        state.is_edit = false;
        state.is_changed = false;
        state.readable_group_id = state.default_readable_group_id;
        state.editable_group_id = state.default_editable_group_id;
        state.is_draft = state.default_is_draft;
        state.is_public = state.default_is_public;
        return state;
    },
    [onClickIsDraft]: state => {
        if (state.is_editable == false) {
            return state;
        }
        state.is_draft = !state.is_draft;
        state.is_changed = true;
        return state;
    },
    [onClickIsPublic]: state => {
        if (state.is_editable == false) {
            return state;
        }
        state.is_public = !state.is_public;
        state.is_changed = true;
        return state;
    },
    [setContent]: (state, action) => {
        state.markdown = action.payload.markdown;
        state.default_markdown = action.payload.markdown;
        state.usergroups = action.payload.usergroups;
        state.is_editable = action.payload.is_editable;
        state.readable_group_id = action.payload.default_readable_group_id;
        state.editable_group_id = action.payload.default_editable_group_id;
        state.default_readable_group_id = action.payload.default_readable_group_id;
        state.default_editable_group_id = action.payload.default_editable_group_id;
        state.default_is_draft = action.payload.default_is_draft;
        state.default_is_public = action.payload.default_is_public;
        state.is_draft = action.payload.default_is_draft;
        state.is_public = action.payload.default_is_public;
        state.is_edit = false
        return state;
    }
});
export default MdEditorReducer;