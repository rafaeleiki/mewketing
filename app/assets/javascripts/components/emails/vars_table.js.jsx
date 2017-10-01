class VarsTable extends React.Component {

    constructor(props) {
        super(props);
        let info = this.extractEmailInfo(props.text);
        this.state = {
            ...info,
            values: props.values
        };
    }

    extractEmailInfo(baseText) {
        let vars = this.getVars(baseText);
        let text = this.getPureText(baseText);
        let images = this.getImages(baseText);
        return { vars, text, images };
    }

    getVars(text = this.state.text) {
        let index = 0;
        let vars = [].concat(this.props.defaultVars);
        while (index >= 0) {
            let { variable, newIndex } = this.findVar(text, index);
            index = newIndex;
            if (variable) {
                vars.push(variable);
            }
        }
        return vars;
    }

    getPureText(text) {
        return text.replace(/<<<.*>>>/, '');
    }

    getImages(text) {
        let begin = text.indexOf(/<<<.*>>>/);
        let images = [];
        if (begin >= 0) {
            begin += 3;
            let end = text.indexOf('>>>', begin);
            let imagesJson = text.substr(begin, end - begin);
            images = JSON.parse(imagesJson);
        }
        return images;
    }

    findVar(text, index) {
        let begin = text.indexOf('{{', index);
        let variable, newIndex;
        if (begin >= 0) {
            begin += 2; // skips {{
            let end = text.indexOf('}}', begin);
            variable = text.substr(begin, end - begin);
            newIndex = end + 2;
        } else {
            newIndex = -1;
        }
        return { variable, newIndex };
    }

    addDataLine() {
        let { values, vars } = this.state;
        let dataLine = {};
        vars.forEach(variable => dataLine[variable] = '');
        values.push(dataLine);
        this.setState({ values });
    }

    getPreviewHTML() {
        let { text, images } = this.state;
        images.forEach(({ name, content }) => {
            const regex = new RegExp(`\\[\\[${name}\\]\\]`, 'g');
            text = text.replace(regex, `<img src="${content}" />`);
        });
        text = text.replace(/\n/g, '<br />');
        return { __html: text };
    }

    getFullBody() {
        let { images } = this.state;
        let text = this.getPreviewHTML().__html;
        return `<<<${JSON.stringify(images)}>>>${text}`;
    }

    addImage(file) {
        let fileReader = new FileReader();
        fileReader.onload = (event) => {
            let fileData = event.target.result;
            let { images, text } = this.state;
            images.push({
                name: file.name,
                content: fileData
            });
            text += `[[${file.name}]]`;
            this.setState({ images, text });
        };
        fileReader.readAsDataURL(file);
    }

    renderLine(dataLine, key, vars) {
        return (
            <tr key={key}>{
                vars.map((variable, index) =>
                    (<td key={index}>
                        <input type="text"
                               name={ `vars_values[${key}][${variable}]` }
                               defaultValue={ dataLine[variable] } />
                    </td>)
                )
            }</tr>
        );
    }

    renderBody() {
        const { text } = this.state;
        const { entity } = this.props;
        return (
            <div className="mdl-textfield mdl-js-textfield mdl-textarea">
                <label className="mdl-textfield__label">Body</label>
                <textarea value={text}
                          id={`${entity}_body`}
                          onChange={(event) => this.setState({ text: event.target.value })}
                          className="mdl-textfield__input mdl-textarea__input">
                </textarea>
            </div>
        );
    }

    renderPreview() {
        return (
            <div className="preview-div">
                <h4 className="">Preview</h4>
                <div dangerouslySetInnerHTML={this.getPreviewHTML()}/>
            </div>
        );
    }

    renderVarsController() {
        let { values, vars } = this.state;
        return (
          <div className="renderVarsController">
              <table className="mdl-data-table mdl-js-data-table mdl-shadow--2dp">
                  <thead>
                  <tr>{ vars.map((variable, i) => <th key={i}>{ variable }</th>) }</tr>
                  </thead>
                  <tbody>
                  { values.map((dataLine, index) => this.renderLine(dataLine, index, vars)) }
                  </tbody>
              </table>
              <br />
              {
                  vars.map((variable, i) =>
                      <input type="hidden" name={ `vars[${i}]` } key={i} value={variable} />
                  )
              }
              <div className="actions-vars">
                <button type="button" onClick={(event) => this.addDataLine()} className="mdl-button mdl-js-button mdl-button--raised mdl-button--colored">Add</button> |
                <button type="button" onClick={(event) => this.setState({ vars: this.getVars() })} className="mdl-button mdl-js-button mdl-button--raised">Refresh</button>
              </div>
          </div>
        );
    }

    render() {
        const { entity, useVars } = this.props;
        return (
            <div>
                <input type="hidden" name={`${entity}[body]`} value={this.getFullBody()} />
                { this.renderBody() }
                <br />
                <input type="file" onChange={(event) => this.addImage(event.target.files[0]) } />
                <hr />
                { this.renderPreview() }
                <hr />
                { useVars ? this.renderVarsController() : null }
            </div>
        );
    }

}

VarsTable.propTypes = {
    text: React.PropTypes.string,
    values: React.PropTypes.array,
    useVars: React.PropTypes.any,
    defaultVars: React.PropTypes.array,
    entity: React.PropTypes.string,
};
