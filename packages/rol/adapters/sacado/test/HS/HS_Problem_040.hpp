// @HEADER
// ************************************************************************
//
//               Rapid Optimization Library (ROL) Package
//                 Copyright (2014) Sandia Corporation
//
// Under terms of Contract DE-AC04-94AL85000, there is a non-exclusive
// license for use of this work by or on behalf of the U.S. Government.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
// 1. Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the Corporation nor the names of the
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY SANDIA CORPORATION "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SANDIA CORPORATION OR THE
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Questions? Contact lead developers:
//              Drew Kouri   (dpkouri@sandia.gov) and
//              Denis Ridzal (dridzal@sandia.gov)
//
// ************************************************************************
// @HEADER

#ifndef HS_PROBLEM_040_HPP
#define HS_PROBLEM_040_HPP

#include "ROL_NonlinearProgram.hpp"

namespace HS {

namespace HS_040 {
template<class Real> 
class Obj {
public:
  template<class ScalarT>
  ScalarT value( const std::vector<ScalarT> &x, Real &tol ) {
    return -x[0]*x[1]*x[2]*x[3];
  }
};

template<class Real>
class EqCon {
public:
  template<class ScalarT> 
  void value( std::vector<ScalarT> &c,
              const std::vector<ScalarT> &x,
              Real &tol ) {
    c[0] = x[0]*x[0]*x[0] + x[1]*x[1] - 1.0;    
    c[1] = x[0]*x[0]*x[3] - x[2];
    c[2] = x[3]*x[3]      - x[1];
  }
};
} // HS_040


template<class Real> 
class Problem_040 : public ROL::NonlinearProgram<Real> {

  template<typename T> using RCP = Teuchos::RCP<T>;

  typedef ROL::NonlinearProgram<Real>   NP;
  typedef ROL::Vector<Real>             V;
  typedef ROL::Objective<Real>          OBJ;
  typedef ROL::Constraint<Real>         CON;

public:

  Problem_040() : NP( dimension_x() ) {
    NP::noBound();
  }

  int dimension_x()  { return 4; }
  int dimension_ce() { return 3; }

  const RCP<OBJ> getObjective() { 
    return Teuchos::rcp( new ROL::Sacado_StdObjective<Real,HS_040::Obj> );
  }

  const RCP<CON> getEqualityConstraint() {
    return Teuchos::rcp( 
      new ROL::Sacado_StdConstraint<Real,HS_040::EqCon> );
  }

  const RCP<const V> getInitialGuess() {
    Real x[] = {0.8,0.8,0.8,0.8};
    return NP::createOptVector(x);
  };
   
  bool initialGuessIsFeasible() { return false; }
  
  Real getInitialObjectiveValue() { 
    return Real(-0.4096);
  }
 
  Real getSolutionObjectiveValue() {
    return Real(-0.25);
  }

  RCP<const V> getSolutionSet() {
    Real a = -1.0/3.0;
    Real b = -1.0/4.0;
    Real c = -11.0/12.0;
    Real x1[] = {std::pow(2.0,a),std::pow(2.0,2*b),-std::pow(2.0,c),-std::pow(2.0,b)};
    Real x2[] = {std::pow(2.0,a),std::pow(2.0,2*b), std::pow(2.0,c), std::pow(2.0,b)};

    return ROL::CreatePartitionedVector(NP::createOptVector(x1), 
                                        NP::createOptVector(x2));
  }
 
};

} // namespace HS

#endif // HS_PROBLEM_040_HPP
