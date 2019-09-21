import {CHANGE_TAB, CHANGE_TEXT,ONCLICK_EDIT,ONCLICK_CANCEL,SET_CONTENT } from "./action_name";
const Actions = {
    changeText(e) {
        return {
            type: CHANGE_TEXT,
            payload: {
                text: e.target.value,
            }
        }
    },
    changeTab(index, last) {
        return {
            type: CHANGE_TAB,
            payload: {
                tabIndex: index,
            }
        }
    },
    onClickEdit(e) {
        return {
            type: ONCLICK_EDIT,
            payload: {
            }
        }
    },

    onClickCancel(e) {
        return {
            type: ONCLICK_CANCEL,
            payload: {
            }
        }
    },
    setContent(content) {
        return {
            type: SET_CONTENT,
            payload: {
                markdown: content
            }
        }
    }
}
export default Actions;