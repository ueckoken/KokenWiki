import { createSlice, configureStore } from "@reduxjs/toolkit"

const initialState = {
    title: "",
    default_title: "",
    markdown: "",
    default_markdown: "",
    usergroups: [],
    is_editing: false,
    is_editable: false,
    is_destroyable: false,
    readable_group_id: 0,
    editable_group_id: 0,
    default_readable_group_id: 0,
    default_editable_group_id: 0,
    parent_page_id: null,
    next_parent_pages: [],
}

const { reducer, actions } = createSlice({
    name: "MdEditor",
    initialState,
    reducers: {
        changeTitle: (state, action) => {
            if (!state.is_editable) {
                return state
            }
            state.title = action.payload
            return state
        },
        changeText: (state, action) => {
            if (!state.is_editable) {
                return state
            }
            state.markdown = action.payload
            return state
        },
        changeReadableGroup: (state, action) => {
            if (!state.is_editable) {
                return state
            }
            state.readable_group_id = action.payload
            return state
        },
        changeEditableGroup: (state, action) => {
            if (!state.is_editable) {
                return state
            }
            state.editable_group_id = action.payload
            return state
        },
        changeParentPage: (state, action) => {
            if (!state.is_editable) {
                return state
            }
            state.parent_page_id = action.payload
            return state
        },
        onClickEdit: (state) => {
            if (!state.is_editable) {
                return state
            }
            state.is_editing = true
            return state
        },
        onClickCancel: (state) => {
            state.title = state.default_title
            state.markdown = state.default_markdown
            state.is_editing = false
            state.readable_group_id = state.default_readable_group_id
            state.editable_group_id = state.default_editable_group_id
            state.parent_page_id = state.default_parent_page_id
            return state
        },
        setContent: (state, action) => {
            state.title = action.payload.title
            state.default_title = action.payload.title
            state.markdown = action.payload.markdown
            state.default_markdown = action.payload.markdown
            state.usergroups = action.payload.usergroups
            state.is_editable = action.payload.is_editable
            state.is_destroyable = action.payload.is_destroyable
            state.readable_group_id = action.payload.readable_group_id
            state.editable_group_id = action.payload.editable_group_id
            state.default_readable_group_id = action.payload.readable_group_id
            state.default_editable_group_id = action.payload.editable_group_id
            state.parent_page_id = action.payload.parent_page_id
            state.default_parent_page_id = action.payload.parent_page_id
            state.next_parent_pages = action.payload.next_parent_pages
            state.is_editing = false
            return state
        },
    },
})

const isChangedSelector = (state) =>
    state.title !== state.default_title ||
    state.markdown !== state.default_markdown ||
    state.readable_group_id !== state.default_readable_group_id ||
    state.editable_group_id !== state.default_editable_group_id ||
    state.parent_page_id !== state.default_parent_page_id

const selectors = {
    isChanged: isChangedSelector,
}

const store = configureStore({
    reducer: reducer,
})

export { store, actions, selectors }
