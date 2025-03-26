import React from 'react';
import { Link } from 'react-router-dom';
import { Phone, Mail, MapPin, Facebook, Instagram, Linkedin } from 'lucide-react';

const Footer = () => {
  return (
    <footer id="contact" className="bg-black text-gray-400 py-16 border-t border-gray-800">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {/* Company Info */}
          <div>
            <h3 className="text-white text-lg font-semibold mb-4">USA Office</h3>
            <div className="space-y-3">
              <div className="flex items-center">
                <Phone className="h-4 w-4 text-orange-500 mr-2" />
                <span className="text-sm">+1 (615) 509-3966</span>
              </div>
              <div className="flex items-center">
                <Mail className="h-4 w-4 text-orange-500 mr-2" />
                <span className="text-sm">sudheer@ishastoneanddecor.com</span>
              </div>
              <div className="flex items-start">
                <MapPin className="h-4 w-4 text-orange-500 mr-2 mt-1" />
                <span className="text-sm">330 Crescent Village Cir,<br />San Jose CA, 95134</span>
              </div>
            </div>
          </div>

          {/* Contact Info */}
          <div>
            <h3 className="text-white text-lg font-semibold mb-4">INDIA Office</h3>
            <div className="space-y-3">
             
              <div className="flex items-center">
                <MapPin className="h-4 w-4 text-orange-500 mr-2" />
                <span className="text-sm">Dakshith Stone and decor</span>
              </div>
              <div className="flex items-start">
                <MapPin className="h-4 w-4 text-orange-500 mr-2 mt-1" />
                <span className="text-sm">Hyderabad<br />Telangana-501512.</span>
              </div>
            </div>
          </div>

          {/* Quick Links */}
          <div>
            <h3 className="text-white text-lg font-semibold mb-4">Quick Links</h3>
            <ul className="space-y-2">
              <li>
                <Link to="/natural-stones" className="text-sm hover:text-orange-500 transition-colors duration-300">
                  Natural Stones
                </Link>
              </li>
              <li>
                <Link to="/quartz" className="text-sm hover:text-orange-500 transition-colors duration-300">
                  Quartz
                </Link>
              </li>
              <li>
                <Link to="/tiles" className="text-sm hover:text-orange-500 transition-colors duration-300">
                  Tiles
                </Link>
              </li>
              <li>
                <Link to="/marbles" className="text-sm hover:text-orange-500 transition-colors duration-300">
                  Marbles
                </Link>
              </li>
              <li>
                <Link to="/spc" className="text-sm hover:text-orange-500 transition-colors duration-300">
                  SPC
                </Link>
              </li>
            </ul>
          </div>

          {/* Social Links */}
          <div>
            <h3 className="text-white text-lg font-semibold mb-4">Connect With Us</h3>
            <div className="flex space-x-4">
              <a 
                href="#" 
                target="_blank" 
                rel="noopener noreferrer"
                className="text-gray-400 hover:text-orange-500 transition-colors duration-300"
              >
                <Facebook className="h-5 w-5" />
              </a>
              <a 
                href="#" 
                target="_blank" 
                rel="noopener noreferrer"
                className="text-gray-400 hover:text-orange-500 transition-colors duration-300"
              >
                <Instagram className="h-5 w-5" />
              </a>
              <a 
                href="#" 
                target="_blank" 
                rel="noopener noreferrer"
                className="text-gray-400 hover:text-orange-500 transition-colors duration-300"
              >
                <Linkedin className="h-5 w-5" />
              </a>
            </div>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="mt-12 pt-8 border-t border-gray-800 text-center">
          <p className="text-sm">© {new Date().getFullYear()} Isha Stone and Decor. All rights reserved.</p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;