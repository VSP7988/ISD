import React, { useState, useEffect } from 'react';
import { bannerImages } from '../config/images';

const slides = [
  {
    image: bannerImages.naturalStones,
    title: "Elevate Your Space",
    subtitle: "With Premium Stone Solutions"
  },
  {
    image: bannerImages.quartz,
    title: "Timeless Beauty",
    subtitle: "Natural Stone Collections"
  },
  {
    image: bannerImages.marbles,
    title: "Modern Elegance",
    subtitle: "Premium Quartz Surfaces"
  }
];

const Hero = () => {
  const [currentSlide, setCurrentSlide] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentSlide((prev) => (prev + 1) % slides.length);
    }, 5000);
    return () => clearInterval(timer);
  }, []);

  return (
    <section className="relative h-screen w-full overflow-hidden" id="home">
      {slides.map((slide, index) => (
        <div
          key={index}
          className={`absolute inset-0 transition-opacity duration-1000 ${
            currentSlide === index ? 'opacity-100' : 'opacity-0'
          }`}
        >
          <div
            className="absolute inset-0 bg-cover bg-center"
            style={{
              backgroundImage: `url(${slide.image})`,
            }}
          >
            <div className="absolute inset-0 bg-black/50" />
          </div>
          
          <div className="relative h-full flex items-center justify-center text-center">
            <div className="max-w-4xl px-4">
              <h1 className="text-4xl md:text-6xl font-bold text-white mb-4 opacity-0 animate-fadeIn">
                {slide.title}
              </h1>
              <p className="text-xl md:text-2xl text-gray-200 mb-8 opacity-0 animate-fadeIn animation-delay-300">
                {slide.subtitle}
              </p>
            </div>
          </div>
        </div>
      ))}

      <div className="absolute bottom-8 left-1/2 transform -translate-x-1/2 flex space-x-2">
        {slides.map((_, index) => (
          <button
            key={index}
            onClick={() => setCurrentSlide(index)}
            className={`w-3 h-3 rounded-full transition-colors duration-300 ${
              currentSlide === index ? 'bg-orange-500' : 'bg-white/50'
            }`}
          />
        ))}
      </div>
    </section>
  );
};

export default Hero;