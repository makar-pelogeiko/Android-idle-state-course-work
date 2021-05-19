using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace parserDataTest
{
    public class DataContainer
    {
        public string name;
        public string desc;
        public int disable; // 0 or 1
        public int latency;
        public ulong power;
        public int residency;
        public ulong usage;
        public ulong time;
    }
}
