import marked from 'marked';
import PropTypes from 'prop-types'
import React from 'react'
import ReactDOM from 'react-dom'
import * as escape from 'escape-html';
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';
import { Provider, connect } from 'react-redux';
import { createStore } from 'redux';
import { Markdown } from "./MdEditor/Markdown"

class CommentList extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        console.log(this.props)
        let comments = JSON.parse(this.props.comments);
        console.log(comments);
        return (
            <div>
                {(comments != null ? comments.map((comment) => {
                    console.log(comment)
                    return (
                        <div>
                            <Markdown markdown={comment.comment} />
                            <form action={this.props.path} method="post">
                                <input
                                    type="hidden"
                                    name={this.props.csrfParams}
                                    value={this.props.csrfToken}
                                />
                                <input
                                    type="hidden"
                                    name="_method"
                                    value={"delete"}
                                />
                                <input
                                    type="hidden"
                                    name="comment[comment_id]"
                                    value={comment.id}
                                />
                                <button
                                    type="submit"
                                    className="btn btn-danger"
                                >削除</button>
                            </form>
                        </div>);
                }) :<div></div>)}
            </div>
            )
            
        }
    }
    
export default CommentList;