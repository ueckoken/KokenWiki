import { createAction } from "@reduxjs/toolkit";

export const changeText = createAction("CHANGE_TEXT", e => ({
    payload: {
        text: e.target.value,
    }
}));

export const onClickEdit = createAction("ONCLICK_EDIT");
export const onClickCancel = createAction("ONCLICK_CANCEL");

export const changeReadableGroup = createAction("CHANGE_READABLE_GROUP", e => ({
    payload: {
        readable_group_id: e.target.value
    }
}));

export const changeEditableGroup = createAction("CHANGE_EDITABLE_GROUP", e => ({
    payload: {
        editable_group_id: e.target.value
    }
}));


export const onClickIsDraft = createAction("ONCLICK_IS_DRAFT");
export const onClickIsPublic = createAction("ONCLICK_IS_PUBLIC");
export const setContent = createAction("SET_CONTENT", (content, usergroups, is_editable, default_readable_group_id, default_editable_group_id, default_is_draft, default_is_public) => {
    if (!Array.isArray(usergroups)) {
        usergroups = [];
    }
    return {
        payload: {
            markdown: content,
            usergroups: usergroups,
            is_editable: is_editable,
            default_readable_group_id: default_readable_group_id,
            default_editable_group_id: default_editable_group_id,
            default_is_draft: default_is_draft,
            default_is_public: default_is_public,
        }
    }
});