import React, { useState, useEffect } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { Menu, X, ChevronDown } from 'lucide-react';

interface NavigationProps {
  setCurrentPage: (page: string) => void;
}

const Navigation = ({ setCurrentPage }: NavigationProps) => {
  const [isOpen, setIsOpen] = useState(false);
  const [activeDropdown, setActiveDropdown] = useState<string | null>(null);
  const [logo, setLogo] = useState<string | null>(null);
  const location = useLocation();
  const navigate = useNavigate();

  useEffect(() => {
    const savedLogo = localStorage.getItem('siteLogo');
    if (savedLogo) {
      setLogo(savedLogo);
    }
  }, []);

  const productCategories = [
    { name: 'Natural Stones', path: '/natural-stones' },
    { name: 'Quartz', path: '/quartz' },
    { name: 'Tiles', path: '/tiles' },
    { name: 'Marbles', path: '/marbles' },
    { name: 'SPC', path: '/spc' }
  ];

  const toggleDropdown = (menu: string) => {
    setActiveDropdown(activeDropdown === menu ? null : menu);
  };

  const handleClose = () => {
    setIsOpen(false);
    setActiveDropdown(null);
  };

  const isActive = (path: string) => {
    return location.pathname === path;
  };

  const scrollToFooter = () => {
    handleClose();
    
    if (location.pathname !== '/') {
      navigate('/');
      // Wait for navigation to complete before scrolling
      setTimeout(() => {
        const footer = document.getElementById('contact');
        if (footer) {
          footer.scrollIntoView({ behavior: 'smooth' });
        }
      }, 100);
    } else {
      const footer = document.getElementById('contact');
      if (footer) {
        footer.scrollIntoView({ behavior: 'smooth' });
      }
    }
  };

  const handleNavigation = (sectionId: string) => {
    handleClose();
    
    if (location.pathname !== '/') {
      navigate('/');
      // Wait for navigation to complete before scrolling
      setTimeout(() => {
        const element = document.getElementById(sectionId);
        if (element) {
          const navHeight = 80;
          const elementPosition = element.getBoundingClientRect().top;
          const offsetPosition = elementPosition + window.pageYOffset - navHeight;
          window.scrollTo({
            top: offsetPosition,
            behavior: 'smooth'
          });
        }
      }, 100);
    } else {
      const element = document.getElementById(sectionId);
      if (element) {
        const navHeight = 80;
        const elementPosition = element.getBoundingClientRect().top;
        const offsetPosition = elementPosition + window.pageYOffset - navHeight;
        window.scrollTo({
          top: offsetPosition,
          behavior: 'smooth'
        });
      }
    }
  };

  return (
    <nav className="fixed w-full bg-orange-500 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-24">
          <div className="flex items-center">
            <Link 
              to="/" 
              onClick={() => {
                handleClose();
                window.scrollTo(0, 0);
              }} 
              className="text-white font-bold text-2xl"
            >
              {logo ? (
                <img src={logo} alt="Site Logo" className="h-60 w-auto" />
              ) : (
                'STONEX'
              )}
            </Link>
          </div>

          {/* Desktop Navigation */}
          <div className="hidden md:block">
            <div className="flex items-center space-x-2">
              <Link 
                to="/"
                onClick={() => {
                  handleClose();
                  window.scrollTo(0, 0);
                }}
                className={`px-3 py-2 text-sm font-medium ${
                  isActive('/') 
                    ? 'text-orange-500 bg-white rounded-md' 
                    : 'text-white hover:bg-white/10 rounded-md transition-colors duration-200'
                }`}
              >
                Home
              </Link>
              
              <button 
                onClick={() => handleNavigation('about')}
                className="px-3 py-2 text-sm font-medium text-white hover:bg-white/10 rounded-md transition-colors duration-200"
              >
                About Us
              </button>
              
              {/* Products Dropdown */}
              <div className="relative">
                <button 
                  onClick={() => toggleDropdown('products')}
                  className="px-3 py-2 text-sm font-medium text-white hover:bg-white/10 rounded-md transition-colors duration-200 flex items-center"
                >
                  Products
                  <ChevronDown className="ml-1 h-4 w-4" />
                </button>
                
                <div className={`absolute left-0 mt-1 w-48 rounded-md shadow-lg bg-white ring-1 ring-black/5 ${
                  activeDropdown === 'products' ? 'block' : 'hidden'
                }`}>
                  <div className="py-1">
                    {productCategories.map((category) => (
                      <Link
                        key={category.name}
                        to={category.path}
                        onClick={handleClose}
                        className={`block px-4 py-2 text-sm ${
                          isActive(category.path)
                            ? 'text-orange-500 bg-orange-50'
                            : 'text-gray-700 hover:bg-orange-50 hover:text-orange-500'
                        } transition-colors duration-200`}
                      >
                        {category.name}
                      </Link>
                    ))}
                  </div>
                </div>
              </div>

              <button 
                onClick={scrollToFooter}
                className="px-3 py-2 text-sm font-medium text-white hover:bg-white/10 rounded-md transition-colors duration-200"
              >
                Contact
              </button>
            </div>
          </div>

          {/* Mobile menu button */}
          <div className="md:hidden">
            <button
              onClick={() => setIsOpen(!isOpen)}
              className="text-white hover:bg-white/10 rounded-md p-2 transition-colors duration-200"
            >
              {isOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile menu */}
      <div className={`md:hidden ${isOpen ? 'block' : 'hidden'}`}>
        <div className="px-2 pt-2 pb-3 space-y-1 bg-orange-500 border-t border-white/10">
          <Link 
            to="/"
            onClick={() => {
              handleClose();
              window.scrollTo(0, 0);
            }}
            className={`block px-3 py-2 rounded-md text-base font-medium ${
              isActive('/') 
                ? 'text-orange-500 bg-white' 
                : 'text-white hover:bg-white/10'
            } transition-colors duration-200`}
          >
            Home
          </Link>
          
          <button
            onClick={() => handleNavigation('about')}
            className="w-full text-left block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-white/10 transition-colors duration-200"
          >
            About Us
          </button>
          
          <button 
            onClick={() => toggleDropdown('mobile-products')}
            className="w-full text-left px-3 py-2 rounded-md text-base font-medium text-white hover:bg-white/10 transition-colors duration-200 flex items-center justify-between"
          >
            Products
            <ChevronDown className={`h-4 w-4 transition-transform duration-200 ${
              activeDropdown === 'mobile-products' ? 'rotate-180' : ''
            }`} />
          </button>
          
          {activeDropdown === 'mobile-products' && (
            <div className="pl-4 space-y-1">
              {productCategories.map((category) => (
                <Link
                  key={category.name}
                  to={category.path}
                  onClick={handleClose}
                  className={`block px-3 py-2 rounded-md text-sm font-medium ${
                    isActive(category.path)
                      ? 'text-orange-500 bg-white'
                      : 'text-white hover:bg-white/10'
                  } transition-colors duration-200`}
                >
                  {category.name}
                </Link>
              ))}
            </div>
          )}
          
          <button
            onClick={scrollToFooter}
            className="w-full text-left block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-white/10 transition-colors duration-200"
          >
            Contact
          </button>
        </div>
      </div>
    </nav>
  );
};

export default Navigation;