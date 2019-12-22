import { createSlice } from "@reduxjs/toolkit"

const initialState = {
    markdown: "",
    default_markdown: "",
    usergroups: [],
    is_edit: false,
    is_editable: false,
    readable_group_id: 0,
    editable_group_id: 0,
    default_readable_group_id: 0,
    default_editable_group_id: 0,
}

const { reducer, actions } = createSlice({
    name: "MdEditor",
    initialState,
    reducers: {
        changeText: (state, action) => {
            if (state.is_editable == false) {
                return state
            }
            state.markdown = action.payload
            return state
        },
        changeReadableGroup: (state, action) => {
            if (state.is_editable == false) {
                return state
            }
            state.readable_group_id = action.payload
            return state
        },
        changeEditableGroup: (state, action) => {
            if (state.is_editable == false) {
                return state
            }
            state.editable_group_id = action.payload
            return state
        },
        onClickEdit: (state) => {
            if (state.is_editable == false) {
                return state
            }
            state.is_edit = true
            return state
        },
        onClickCancel: (state) => {
            state.markdown = state.default_markdown
            state.is_edit = false
            state.readable_group_id = state.default_readable_group_id
            state.editable_group_id = state.default_editable_group_id
            return state
        },
        setContent: (state, action) => {
            state.markdown = action.payload.markdown
            state.default_markdown = action.payload.markdown
            state.usergroups = action.payload.usergroups
            state.is_editable = action.payload.is_editable
            state.readable_group_id = action.payload.readable_group_id
            state.editable_group_id = action.payload.editable_group_id
            state.default_readable_group_id = action.payload.readable_group_id
            state.default_editable_group_id = action.payload.editable_group_id
            state.is_edit = false
            return state
        },
    },
})

const isChangedSelector = (state) =>
    state.markdown !== state.default_markdown ||
    state.readable_group_id !== state.default_readable_group_id ||
    state.editable_group_id !== state.default_editable_group_id

const selectors = {
    isChanged: isChangedSelector,
}

export { reducer, actions, selectors }
