import React from 'react';

const About = () => {
  return (
    <section id="about" className="py-20 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          <div className="space-y-6">
            <h2 className="text-3xl md:text-4xl font-bold text-black">
              About
              <span className="text-orange-500"> Isha Stone and Decor</span>
            </h2>
            <p className="text-gray-600 leading-relaxed">
              Redefining elegance with the timeless beauty of natural stones. Sourced from India and crafted for the world, our curated collection combines heritage, quality, and unmatched craftsmanship. From countertops to decor, we bring nature's finest to elevate every space.
            </p>
            <p className="text-gray-600 leading-relaxed">
              At Isha Stones and Decor, we pride ourselves on delivering the finest construction stones sourced from the rich geological heritage of India to projects around the world. Our diverse range includes natural stones, tiles, quartz, and porcelain, carefully selected to meet the highest standards of quality and design. Each stone we offer tells a story of Earth's timeless artistry, shaped over millennia, and crafted to transform spaces into enduring works of beauty. Committed to sustainability and excellence, we are your trusted partner in bringing the strength, elegance, and legacy of Indian stones to life in every architectural endeavor.
            </p>
           
          </div>
          <div className="relative">
            <div className="aspect-square rounded-lg overflow-hidden">
              <img
                src="https://images.unsplash.com/photo-1600585154526-990dced4db0d"
                alt="Stonework craftsmanship"
                className="w-full h-full object-cover"
              />
            </div>
            <div className="absolute -bottom-6 -left-6 w-48 h-48 bg-orange-500/20 rounded-lg -z-10" />
            <div className="absolute -top-6 -right-6 w-48 h-48 bg-orange-500/20 rounded-lg -z-10" />
          </div>
        </div>
      </div>
    </section>
  );
};

export default About;