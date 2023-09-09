import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final String description;

  Product(this.name, this.price, this.description);
}

final List<Product> products = [
  Product('Product 1', 20.0, 'Description for Product 1'),
  Product('Product 2', 30.0, 'Description for Product 2'),
  Product('Product 3', 40.0, 'Description for Product 3'),
  //  We Can Add more products as needed
];

void main() {
  runApp(MaterialApp(
    home: ProductListScreen(),
  ));
}

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isFront = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(
                _isFront ? _animation.value * 3.141592 : (1 - _animation.value) * 3.141592);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: _isFront ? _buildFrontCard() : _buildBackCard(),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Card(
      child: ListTile(
        title: Text(widget.product.name),
        subtitle: Text('\$${widget.product.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: Icon(Icons.details),
          onPressed: _flipCard,
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Card(
      child: ListTile(
        title: Text('Description'),
        subtitle: Text(
          widget.product.description,
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _flipCard,
        ),
      ),
    );
  }
}
