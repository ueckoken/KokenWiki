import {CHANGE_TAB, CHANGE_TEXT,ONCLICK_EDIT,ONCLICK_CANCEL,SET_CONTENT, CHANGE_READABLE_GROUP, CHANGE_EDITABLE_GROUP, ONCLICK_IS_DRAFT, ONCLICK_IS_PUBLIC } from "./action_name";

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
    
    changeReadableGroup(e){
        return {
            type: CHANGE_READABLE_GROUP,
            payload: {
                readable_group_id: e.target.value
            }
        }
    },
    
    changeEditableGroup(e){
        return {
            type: CHANGE_EDITABLE_GROUP,
            payload: {
                editable_group_id: e.target.value
            }
        }
    },
    onClickIsDraft(e){
        return {
            type: ONCLICK_IS_DRAFT,
            payload: {
            }
        }
    },
    onClickIsPublic(e){
        return {
            type: ONCLICK_IS_PUBLIC,
            payload: {
            }
        }
    },
    setContent(content,usergroups,is_editable,default_readable_group_id,default_editable_group_id,default_is_draft,default_is_public) {
        if(!Array.isArray(usergroups)){
            usergroups = [];
        }
        return {
            type: SET_CONTENT,
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
    }
}
export default Actions;