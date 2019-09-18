import marked from 'marked';
import PropTypes from 'prop-types'
import React from 'react'
import ReactDOM from 'react-dom'
import * as escape from 'escape-html';
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';
import { hidden } from 'ansi-colors';
class MdEditor extends React.Component {
    
    constructor(props) {
        super(props);
        marked.setOptions({
            sanitize: true,
        });
        this.state = {
            markdown: this.props.markdown,
            tabIndex: 0,
            is_edit: false,
            is_changed: false
        };
    }

    handleSelect(index, last) {
        //console.log('Selected tab: ' + index + ', Last tab: ' + last);
        this.setState({
            tabIndex: index
        });
    }
    onClickEditBtn(e) {
        this.setState({
            is_edit: true
        });
    }
    onClickDeleteBtn(e) {
        this.setState({
            is_edit: false,
            markdown: this.props.markdown
        });
    }
    render() {
        return (
            <React.Fragment>
                <div hidden={this.state.is_edit}>
                    <button className="btn btn-secondary" onClick={this.onClickEditBtn.bind(this)}>編集</button>
                    <Markdown md={this.state.markdown}></Markdown>
                </div>
                <div hidden={!this.state.is_edit}>
                    <div className="d-lg-none">
                        <MdEditorSm
                            tabSelected={this.handleSelect.bind(this)}
                            markdown={this.state.markdown}
                            tabIndex={this.state.tabIndex}
                            onChangeText={this.onChangeText.bind(this)}>

                        </MdEditorSm>
                    </div>
                    <div className="d-none d-lg-flex width100">
                        <MdEditorLg
                            tabSelected={this.handleSelect.bind(this)}
                            markdown={this.state.markdown}
                            tabIndex={this.state.tabIndex}
                            onChangeText={this.onChangeText.bind(this)}>

                        </MdEditorLg>
                    </div>
                    <button className="btn btn-secondary" onClick={this.onClickDeleteBtn.bind(this)}>破棄</button>
                </div>
            </React.Fragment>
        );
    }
    onChangeText(e) {
        this.setState({
            markdown: e.target.value,
            is_changed: true
        });
    }
}
class MdEditorSm extends React.Component{

    constructor(props) {
        super(props);
    }
    render() {
        return (
            <form>
                <Tabs
                    onSelect={this.props.tabSelected}
                    selectedIndex={this.props.tabIndex}
                >

                    <TabList>
                        <Tab>プレビュー</Tab>
                        <Tab>編集</Tab>
                    </TabList>

                    <TabPanel>
                        <Markdown md={this.props.markdown}></Markdown>
                    </TabPanel>
                    <TabPanel>
                        <Editor text={this.props.markdown} onChange={this.props.onChangeText}>
                        </Editor>
                    </TabPanel>

                </Tabs>
            </form>
        );
    }
    onChangeText(e) {
        this.setState({
            markdown: e.target.value
        });
    }
}
class MdEditorLg extends React.Component{

    constructor(props) {
        super(props);
    }
    render() {
        return (
            <div className="row width100">
                <div className="col-6">
                    <Tabs>
                        <TabList>
                            <Tab>プレビュー</Tab>
                        </TabList>

                        <TabPanel>
                            <Markdown md={this.props.markdown}></Markdown>
                        </TabPanel>
                    </Tabs>
                </div>
                <div className="col-6">

                    <Tabs>
                        <TabList>
                            <Tab>編集</Tab>
                        </TabList>
                        <TabPanel>
                            <Editor text={this.props.markdown} onChange={this.props.onChangeText}>
                            </Editor>
                        </TabPanel>

                    </Tabs>
                </div>
            </div>
        );
    }
}
class Editor extends React.Component {
    constructor(props) {
        super(props);
    }
    render() {
        return <div>
            <textarea
                className="form-control"
                value={this.props.text}
                onChange={this.props.onChange}
                name="markdown">

            </textarea>
        </div>
    }
}
class Markdown extends React.Component {
    constructor(props) {
        super(props);
    }
    render() {
        const html = marked(escape(this.props.md));

        return (
            <div className="" dangerouslySetInnerHTML={{
                __html: html
            }}>
        </div>);
    }
}

export default MdEditor;