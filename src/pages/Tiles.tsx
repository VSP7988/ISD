import React, { useState } from 'react';
import Lightbox from "yet-another-react-lightbox";
import "yet-another-react-lightbox/styles.css";
import { ChevronLeft, ChevronRight } from 'lucide-react';
import { productImages } from '../config/images';
import DownloadBrochure from '../components/DownloadBrochure';

const tilesGallery = [
  {
      src: "/images/tiles/1.jpg",
      title: ""
    },
    {
      src: "/images/tiles/2.jpg",
      title: ""
    },
    {
      src: "images/tiles/3.jpg",
      title: ""
    },
    {
      src: "images/tiles/4.jpg",
      title: ""
    },
    {
      src: "images/tiles/5.jpg",
      title: ""
    },
    {
      src: "images/tiles/6.jpg",
      title: ""
    }
];

const Tiles = () => {
  const [index, setIndex] = useState(-1);

  return (
    <div className="min-h-screen bg-black">
      {/* Hero Section */}
      <div className="relative h-[70vh] w-full overflow-hidden">
        <div
          className="absolute inset-0 bg-cover bg-center"
          style={{
            backgroundImage: `url(${productImages.tiles})`,
          }}
        >
          <div className="absolute inset-0 bg-black/50" />
        </div>
        <div className="relative h-full flex items-center justify-center">
          <div className="text-center">
            <h1 className="text-5xl md:text-7xl font-bold text-white mb-6 animate-fadeIn">
              Luxury <span className="text-orange-500">Tiles</span>
            </h1>
            <DownloadBrochure category="Tiles" />
          </div>
        </div>
      </div>

      {/* Description Section */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-8">
            Versatile <span className="text-orange-500">Design Solutions</span>
          </h2>
          <p className="text-gray-400 text-lg leading-relaxed">
            Our extensive tile collection offers endless possibilities for both residential and commercial spaces. From sleek porcelain to handcrafted ceramics, each tile is selected for its superior quality and design versatility. Whether you're looking to create a bold statement or achieve subtle elegance, our range of tiles provides the perfect foundation for any design vision. With options suitable for floors, walls, and specialty applications, we help bring your creative concepts to life.
          </p>
        </div>
      </section>

      {/* Gallery Section */}
      <section className="py-20 bg-gray-900">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {tilesGallery.map((image, i) => (
              <div
                key={i}
                className="group relative cursor-pointer overflow-hidden rounded-lg"
                onClick={() => setIndex(i)}
              >
                <div className="aspect-square">
                  <img
                    src={image.src}
                    alt={image.title}
                    className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                  />
                </div>
                <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-end">
                  <p className="text-white font-semibold p-6">{image.title}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Lightbox */}
      <Lightbox
        slides={tilesGallery}
        open={index >= 0}
        index={index}
        close={() => setIndex(-1)}
        styles={{
          container: { backgroundColor: 'rgba(0, 0, 0, .95)' }
        }}
        render={{
          iconPrev: () => <ChevronLeft className="w-6 h-6" />,
          iconNext: () => <ChevronRight className="w-6 h-6" />,
          buttonPrev: (props) => {
            if (!props) return null;
            return (
              <button
                type="button"
                onClick={props.onClick}
                className="absolute left-4 top-1/2 -translate-y-1/2 bg-orange-500 p-2 rounded-full hover:bg-orange-400 transition-colors duration-300 z-50"
                disabled={!props.onClick}
              >
                <ChevronLeft className="w-6 h-6 text-black" />
              </button>
            );
          },
          buttonNext: (props) => {
            if (!props) return null;
            return (
              <button
                type="button"
                onClick={props.onClick}
                className="absolute right-4 top-1/2 -translate-y-1/2 bg-orange-500 p-2 rounded-full hover:bg-orange-400 transition-colors duration-300 z-50"
                disabled={!props.onClick}
              >
                <ChevronRight className="w-6 h-6 text-black" />
              </button>
            );
          }
        }}
      />
    </div>
  );
};

export default Tiles;