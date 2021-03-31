import {
    createSlice,
    configureStore,
    PayloadAction,
    Selector,
} from "@reduxjs/toolkit"
import { useSelector, TypedUseSelectorHook } from "react-redux"

type UserGroup = {
    id: string | number
    name: string
}

type ParentPage = {
    id: number
    path: string
}

export type State = {
    title: string
    default_title: string
    markdown: string
    default_markdown: string
    usergroups: UserGroup[]
    is_editing: boolean
    is_editable: boolean
    is_destroyable: boolean
    readable_group_id: number
    editable_group_id: number
    default_readable_group_id: number
    default_editable_group_id: number
    parent_page_id: number | null
    default_parent_page_id: number | null
    next_parent_pages: ParentPage[]
}

const initialState: State = {
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
    default_parent_page_id: null,
    next_parent_pages: [],
}

const { reducer, actions } = createSlice({
    name: "MdEditor",
    initialState,
    reducers: {
        changeTitle: (state, action: PayloadAction<State["title"]>) => {
            if (!state.is_editable) {
                return state
            }
            state.title = action.payload
            return state
        },
        changeText: (state, action: PayloadAction<State["markdown"]>) => {
            if (!state.is_editable) {
                return state
            }
            state.markdown = action.payload
            return state
        },
        changeReadableGroup: (
            state,
            action: PayloadAction<State["readable_group_id"]>
        ) => {
            if (!state.is_editable) {
                return state
            }
            state.readable_group_id = action.payload
            return state
        },
        changeEditableGroup: (
            state,
            action: PayloadAction<State["editable_group_id"]>
        ) => {
            if (!state.is_editable) {
                return state
            }
            state.editable_group_id = action.payload
            return state
        },
        changeParentPage: (
            state,
            action: PayloadAction<State["parent_page_id"]>
        ) => {
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
        setContent: (
            state,
            action: PayloadAction<
                Pick<
                    State,
                    | "title"
                    | "markdown"
                    | "usergroups"
                    | "is_editable"
                    | "is_destroyable"
                    | "readable_group_id"
                    | "editable_group_id"
                    | "parent_page_id"
                    | "next_parent_pages"
                >
            >
        ) => {
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

const isChangedSelector: Selector<State, boolean> = (state) =>
    state.title !== state.default_title ||
    state.markdown !== state.default_markdown ||
    state.readable_group_id !== state.default_readable_group_id ||
    state.editable_group_id !== state.default_editable_group_id ||
    state.parent_page_id !== state.default_parent_page_id

const selectors = {
    isChanged: isChangedSelector,
}

const useTypedSelector: TypedUseSelectorHook<State> = useSelector

const store = configureStore({
    reducer: reducer,
})

export { store, actions, selectors, useTypedSelector }
