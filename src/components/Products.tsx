import React from 'react';
import { ArrowRight } from 'lucide-react';
import { Link } from 'react-router-dom';
import { productImages } from '../config/images';

const products = [
  {
    category: "Natural Stones",
    image: productImages.naturalStones,
    description: "Discover the timeless beauty of natural stone surfaces."
  },
  {
    category: "Quartz",
    image: productImages.quartz,
    description: "Premium engineered quartz for durability and elegance."
  },
  {
    category: "Tiles",
    image: productImages.tiles,
    description: "Versatile tile solutions for any space."
  },
  {
    category: "Marbles",
    image: productImages.marbles,
    description: "Luxurious marble selections from around the world."
  },
  {
    category: "SPC",
    image: productImages.spc,
    description: "Modern Stone Polymer Composite flooring solutions."
  }
];

const Products = () => {
  return (
    <section id="products" className="py-20 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-black mb-4">
            Our <span className="text-orange-500">Collections</span>
          </h2>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {products.map((product) => (
            <div
              key={product.category}
              className="group relative overflow-hidden rounded-lg bg-gray-100"
            >
              <div className="aspect-square overflow-hidden">
                <img
                  src={product.image}
                  alt={product.category}
                  className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                />
              </div>
              <div className="absolute inset-0 bg-gradient-to-t from-black/80 to-transparent flex flex-col justify-end p-6">
                <h3 className="text-xl font-bold text-white mb-2">{product.category}</h3>
                
                <Link
                  to={`/${product.category.toLowerCase().replace(' ', '-')}`}
                  className="inline-flex items-center text-orange-500 hover:text-orange-400 transition-colors duration-300"
                >
                  View More <ArrowRight className="ml-2 h-4 w-4" />
                </Link>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Products;