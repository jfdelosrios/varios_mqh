//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Trade\Trade.mqh>


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string EnumTimeFrameToString(const ENUM_TIMEFRAMES periodo1)
  {
   switch(periodo1)
     {
      case PERIOD_MN1:
         return "MENSUAL";
         break;
      case PERIOD_W1:
         return "SEMANAL";
         break;
      case PERIOD_D1:
         return "DIARIO";
         break;
      case PERIOD_H12:
         return "12 HORAS";
         break;
      case PERIOD_H8:
         return "8 HORAS";
         break;
      case PERIOD_H6:
         return "6 HORAS";
         break;
      case PERIOD_H4:
         return "4 HORAS";
         break;
      case PERIOD_H3:
         return "3 HORAS";
         break;
      case PERIOD_H2:
         return "2 HORAS";
         break;
      case PERIOD_H1:
         return "1 HORA";
         break;
      case PERIOD_M30:
         return "30 MINUTOS";
         break;
      case PERIOD_M20:
         return "20 MINUTOS";
         break;
      case PERIOD_M15:
         return "15 MINUTOS";
         break;
      case PERIOD_M12:
         return "12 MINUTOS";
         break;
      case PERIOD_M10:
         return "10 MINUTOS";
         break;
      case PERIOD_M6:
         return "6 MINUTOS";
         break;
      case PERIOD_M5:
         return "5 MINUTOS";
         break;
      case PERIOD_M4:
         return "4 MINUTOS";
         break;
      case PERIOD_M3:
         return "3 MINUTOS";
         break;
      case PERIOD_M2:
         return "2 MINUTOS";
         break;
      case PERIOD_M1:
         return "1 MINUTO";
         break;
      default:
         return "NULL";
         break;
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool EnviarMensajeCelular(const string _mensaje)
  {

   if(MQLInfoInteger(MQL_TESTER))
      return true;

   if(TerminalInfoInteger(TERMINAL_NOTIFICATIONS_ENABLED) == 0)
     {
      Print("notificaciones en el celular no estan activas");
      return false;
     }


   if(TerminalInfoInteger(TERMINAL_MQID) == 0)
     {
      Print("No hay presencia de MetaQuotes ID ");
      return false;
     }

   if(!SendNotification(_mensaje))
     {
      Print("!SendNotification " + IntegerToString(_LastError));
      return false;
     }

   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool EnviarMensaje(
   const string _file,
   const string _mensaje,
   const bool _celular
)
  {

   Print(_mensaje);

   if(_celular)
      EnviarMensajeCelular(
         _file + ": " + _mensaje + "\n" + TimeToString(TimeCurrent())
      );

   return true;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CerrarTodasLasPosiciones()
  {

   CTrade m_orden;

   CPositionInfo positionInfo;

   for(int _cont = (PositionsTotal() - 1); _cont >= 0; _cont--)
     {

      if(!positionInfo.SelectByIndex(_cont))
        {
         Print(__FUNCTION__ + ", error "+IntegerToString(_LastError));

         if(_LastError == ERR_TRADE_POSITION_NOT_FOUND)
            ResetLastError();

         continue;
        }

      positionInfo.StoreState();

      if(!m_orden.PositionClose(
            positionInfo.Ticket(),
            100
         ))
        {

         m_orden.PrintResult();

         Print("!PositionClose " + IntegerToString(_LastError));

         if(!MQLInfoInteger(MQL_TESTER))
            ResetLastError();

        }

     }

  }
//+------------------------------------------------------------------+
