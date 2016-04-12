#include "tolua.h"

class Point
{
  double m_x, m_y;
public:
  Point (double x, double y)
  : m_x(x), m_y(y)
  {
  }
  double X () const
  {
    return m_x;
  }
  double Y () const
  {
    return m_y;
  }
  int gets (lua_State* L) const
  {
    tolua_pushnumber(L,m_x);
    tolua_pushnumber(L,m_y);
    return 2;
  }
};

