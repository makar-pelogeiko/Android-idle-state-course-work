using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace parserDataTest
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Write("input path of files: ");
            string path = Console.ReadLine();
            Console.Write("input predicate of file: ");
            string predicate = Console.ReadLine();
            Parser notePars = new Parser(path, 1);
            notePars.doParse(predicate);
            notePars.WriteData("readyData.txt");
        }
    }
}
