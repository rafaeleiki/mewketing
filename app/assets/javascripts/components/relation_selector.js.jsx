class RelationSelector extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      data: [],
      query: '',
    };
    this.loadFromServer();
  }

  loadFromServer() {
    const { query } = this.state;
    $.ajax({
      url: this.props.url,
      data: { query }
    }).done((response) => {
      let { data } = response;
      data = this.extractRelations(data);
      this.setState({ data });
    });
  }

  extractRelations(data) {
    const { keyName } = this.props;
    const relationList = this.getRelations();
    const idSet = new Set(relationList.map((r) => r[keyName]));
    data.forEach((relation) => {
      if (!idSet.has(relation[keyName])) {
        if (relation.id) {
          relation.persist = true;
        }
        relationList.push(relation);
      }
    });
    return relationList;
  }

  getRelations() {
    let relationsSaved = this.getRelationsWillBeSaved();
    relationsSaved = relationsSaved.concat(this.getRelationsWillBeDeleted());
    return relationsSaved;
  }

  getRelationsWillBeSaved() {
    return this.getRelationsByCondition(['persist']);
  }

  getRelationsWillBeDeleted() {
    return this.getRelationsByCondition(['delete', 'id']);
  }

  getRelationsByCondition(conditions) {
    const selectedRelations  = [];
    this.state.data.forEach((relation) => {
      if (conditions.every((condition) => relation[condition])) {
        selectedRelations.push(relation);
      }
    });
    return selectedRelations;
  }

  getRelationControllers() {
    return {
      DELETE: (index) => this.getDeleteController(index),
      ADD: (index) => this.getAddController(index),
    };
  }

  getDeleteController(index) {
    return (<button type="button" onClick={() => this.remove(index)} className="btn btn-secondary">
      Remove
    </button>);
  }

  remove(index) {
    this.changeData(index, {
      delete: {$set: true},
      persist: {$set: false},
    });
  }

  getAddController(index) {
    return (<button type="button" onClick={() => this.persist(index)} className="btn btn-secondary">
      Add
    </button>);
  }

  persist(index) {
    this.changeData(index, {
      delete: {$set: false},
      persist: {$set: true},
    });
  }

  changeData(index, changeObject) {
    this.setState(React.addons.update(this.state, {
      data: {
        [index]: changeObject
      }
    }));
  }

  relationList() {
    const controllers = this.getRelationControllers();
    const list = this.state.data.map((relation, key) => this.props.render(relation, key, controllers));
    return list;
  }

  hiddenAttributes() {
    const attrPrefix = this.getAttrPrefix();
    const { keyName } = this.props;
    return this.state.data.map((relation, key) => {
      let attributes = [];
      const { id } = relation;
      const keyId = relation[keyName];
      if (id) {
        attributes.push(<input name={`${attrPrefix}[${key}][id]`} type="hidden" value={id} />)
      }
      if (relation.persist) {
        attributes.push(<input name={`${attrPrefix}[${key}][${keyName}]`} type="hidden" value={keyId} />)
      } else if (relation.delete) {
        attributes.push(<input name={`${attrPrefix}[${key}][_destroy]`} type="hidden" value="1" />)
      }
      return attributes;
    });
  }

  getAttrPrefix() {
    const { entityName, attributeName } = this.props;
    return `${entityName}[${attributeName}_attributes]`;
  }

  search(query) {
    this.state.query = query;
    this.loadFromServer();
  }

  render() {
    const relationList = this.relationList();
    const hiddenAttributes = this.hiddenAttributes();
    return (
      <div>
        <input type="search"
               onChange={(event) => this.search(event.target.value)}
               onKeyDown={(event) => event.keyCode === 13 && event.preventDefault()}
        />
        <ul className="relation-list">{relationList}</ul>
        { hiddenAttributes }
      </div>
    );
  }
}

RelationSelector.propTypes = {
  url: React.PropTypes.string,
  id: React.PropTypes.number,
  render: React.PropTypes.func,
  entityName: React.PropTypes.string,
  attributeName: React.PropTypes.string,
  keyName: React.PropTypes.string,
};
