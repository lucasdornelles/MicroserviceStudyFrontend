import React from "react";

class ProductForm extends React.Component {
  constructor() {
    super();
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(event) {
    event.preventDefault();
    const form = event.target;
    const data = new FormData(form);

    fetch('https://microservice-study-backend.herokuapp.com/postproduct', {
      method: 'POST',
      body: data,
    });

    console.log(data);
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <input name="name" type="text" />

        <input name="price" type="number" />

        <input name="category" type="text" />

        <input name="description" type="text" />

        <input name="quantity" type="number" />

        <button>Post Product</button>
      </form>
    )
  }
}

export default ProductForm;
