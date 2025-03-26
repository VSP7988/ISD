import React from 'react';
import { Phone, Mail, MapPin, Facebook, Instagram, Linkedin as LinkedIn } from 'lucide-react';

const Contact = () => {
  return (
    <section id="contact" className="py-20 bg-black">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid md:grid-cols-2 gap-12">
          <div>
            <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
              Get in <span className="text-orange-500">Touch</span>
            </h2>
            <p className="text-gray-400 mb-8">
              Have questions about our products or services? We're here to help. Contact us using the form or reach out directly through our contact information.
            </p>
            
            <div className="space-y-4 mb-8">
              <div className="flex items-center text-gray-300">
                <Phone className="h-5 w-5 text-orange-500 mr-3" />
                <span>+1 (615) 509-3966</span>
              </div>
              <div className="flex items-center text-gray-300">
                <Mail className="h-5 w-5 text-orange-500 mr-3" />
                <span>sudheer@ishastoneanddecor.com</span>
              </div>
              <div className="flex items-center text-gray-300">
                <MapPin className="h-5 w-5 text-orange-500 mr-3" />
                <span>330 Crescent Village Cir, San Jose CA, 95134</span>
              </div>
            </div>

            <div className="flex space-x-4">
              <a href="#" className="text-gray-400 hover:text-orange-500 transition-colors duration-300">
                <Facebook className="h-6 w-6" />
              </a>
              <a href="#" className="text-gray-400 hover:text-orange-500 transition-colors duration-300">
                <Instagram className="h-6 w-6" />
              </a>
              <a href="#" className="text-gray-400 hover:text-orange-500 transition-colors duration-300">
                <LinkedIn className="h-6 w-6" />
              </a>
            </div>
          </div>

          <div className="bg-gray-900 p-8 rounded-lg">
            <form className="space-y-6">
              <div>
                <label htmlFor="name" className="block text-sm font-medium text-gray-300 mb-2">
                  Name
                </label>
                <input
                  type="text"
                  id="name"
                  className="w-full px-4 py-2 bg-black border border-gray-700 rounded-lg focus:outline-none focus:border-orange-500 text-white"
                  placeholder="Your name"
                />
              </div>
              <div>
                <label htmlFor="email" className="block text-sm font-medium text-gray-300 mb-2">
                  Email
                </label>
                <input
                  type="email"
                  id="email"
                  className="w-full px-4 py-2 bg-black border border-gray-700 rounded-lg focus:outline-none focus:border-orange-500 text-white"
                  placeholder="your@email.com"
                />
              </div>
              <div>
                <label htmlFor="message" className="block text-sm font-medium text-gray-300 mb-2">
                  Message
                </label>
                <textarea
                  id="message"
                  rows={4}
                  className="w-full px-4 py-2 bg-black border border-gray-700 rounded-lg focus:outline-none focus:border-orange-500 text-white"
                  placeholder="Your message"
                />
              </div>
              <button
                type="submit"
                className="w-full px-6 py-3 bg-orange-500 text-black font-medium rounded-lg hover:bg-orange-400 transition-colors duration-300"
              >
                Send Message
              </button>
            </form>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Contact;