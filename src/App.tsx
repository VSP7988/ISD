import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navigation from './components/Navigation';
import Hero from './components/Hero';
import About from './components/About';
import BrandNote from './components/BrandNote';
import Products from './components/Products';
import Footer from './components/Footer';
import NaturalStones from './pages/NaturalStones';
import Quartz from './pages/Quartz';
import Tiles from './pages/Tiles';
import Marbles from './pages/Marbles';
import SPC from './pages/SPC';
import Login from './pages/auth/Login';
import AdminDashboard from './pages/admin/AdminDashboard';
import LogoManagement from './pages/admin/LogoManagement';
import ProtectedRoute from './components/ProtectedRoute';

function App() {
  const [currentPage, setCurrentPage] = useState('home');

  return (
    <Router>
      <div className="min-h-screen bg-black text-white flex flex-col">
        <Navigation setCurrentPage={setCurrentPage} />
        <div className="flex-grow">
          <Routes>
            <Route path="/" element={
              <>
                <Hero />
                <About />
                <BrandNote />
                <Products />
              </>
            } />
            <Route path="/natural-stones" element={<NaturalStones />} />
            <Route path="/quartz" element={<Quartz />} />
            <Route path="/tiles" element={<Tiles />} />
            <Route path="/marbles" element={<Marbles />} />
            <Route path="/spc" element={<SPC />} />
            <Route path="/login" element={<Login />} />
            <Route path="/admin" element={
              <ProtectedRoute>
                <AdminDashboard />
              </ProtectedRoute>
            } />
            <Route path="/admin/logo" element={
              <ProtectedRoute>
                <LogoManagement />
              </ProtectedRoute>
            } />
          </Routes>
        </div>
        <Footer />
      </div>
    </Router>
  );
}

export default App;