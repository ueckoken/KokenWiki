import { createAction } from "@reduxjs/toolkit";

export const changeText = createAction("CHANGE_TEXT");
export const onClickEdit = createAction("ONCLICK_EDIT");
export const onClickCancel = createAction("ONCLICK_CANCEL");
export const changeReadableGroup = createAction("CHANGE_READABLE_GROUP");
export const changeEditableGroup = createAction("CHANGE_EDITABLE_GROUP");
export const onClickIsDraft = createAction("ONCLICK_IS_DRAFT");
export const onClickIsPublic = createAction("ONCLICK_IS_PUBLIC");
export const setContent = createAction("SET_CONTENT");