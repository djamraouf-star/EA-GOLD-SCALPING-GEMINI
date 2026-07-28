//+------------------------------------------------------------------+
//|                                                       Logger.mqh |
//+------------------------------------------------------------------+
#ifndef LOGGER_MQH
#define LOGGER_MQH

class CLogger
{
private:
   int m_fileHandle;
   string m_prefix;

public:
   CLogger() : m_fileHandle(INVALID_HANDLE), m_prefix("EA") {}

   void Init(string prefix)
   {
      m_prefix = prefix;
      string fileName = prefix + "_" + TimeToString(TimeCurrent(), TIME_DATE) + ".log";
      m_fileHandle = FileOpen(fileName, FILE_WRITE|FILE_READ|FILE_TXT|FILE_SHARE_READ);
      if(m_fileHandle != INVALID_HANDLE) {
         FileSeek(m_fileHandle, 0, SEEK_END);
      }
   }

   void Deinit()
   {
      if(m_fileHandle != INVALID_HANDLE) {
         FileClose(m_fileHandle);
         m_fileHandle = INVALID_HANDLE;
      }
   }

   void Log(string level, string module, string text)
   {
      string timeStr = TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS);
      string formatted = StringFormat("[%s] [%s] [%s] %s", timeStr, level, module, text);
      Print(formatted);

      if(m_fileHandle != INVALID_HANDLE) {
         FileWriteString(m_fileHandle, formatted + "\r\n");
         FileFlush(m_fileHandle);
      }
   }
};

#endif
