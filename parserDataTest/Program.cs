using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace parserDataTest
{
    class Program
    {
        static void HugeTest()
        {
            Console.WriteLine("--------------HUGE TEST-------------");
            Console.Write("input path of files all tests: ");
            string path = Console.ReadLine();
            Console.Write("number of tests: ");
            int tests = Int32.Parse(Console.ReadLine());
            Console.Write("number of cpus (6): ");
            int nCpu = Int32.Parse(Console.ReadLine());
            Console.Write("number of idle states (2): ");
            int nState = Int32.Parse(Console.ReadLine());
            Console.Write("sumbol of padding cpus (\\t\\t): ");
            string custPadder = Console.ReadLine();


            string[] testblock = { "\\Results_ladder", "\\Results_menu", "\\Results_teo" };
            string[] testname = { "\\gaming", "\\reading", "\\notes", "\\watching", "\\youtube" };
            string[] predicate = { "game", "read", "note", "watch", "youtube" };
            foreach (var block in testblock)
            {
                for (int i = 0; i < testname.Length; ++i)
                {
                    string currentPath = path + block + testname[i];
                    Console.WriteLine("work with: " + currentPath);
                    Parser notePars = new Parser(currentPath, tests, nCpu, nState, custPadder);
                    notePars.DoParse(predicate[i]);
                    notePars.WriteData("readyData.txt");
                    Directory.SetCurrentDirectory(path + "\\Parsed");
                    string output = block.Split('\\')[1] + "_" + predicate[i] + "_readyData.txt";
                    Console.WriteLine("output: " + output);
                    notePars.WriteData(output);
                }
            }
            Console.WriteLine("-----all done-----");
        }

        static void FastTest()
        {
            Console.WriteLine("--------------FAST TEST-------------");
            Console.Write("input path of files all tests: ");
            string path = Console.ReadLine();
            Console.Write("number of tests: ");
            int tests = Int32.Parse(Console.ReadLine());


            string[] testblock = { "\\Results_ladder", "\\Results_menu", "\\Results_teo" };
            string[] testname = { "\\gaming", "\\reading", "\\notes", "\\watching", "\\youtube" };
            string[] predicate = { "game", "read", "note", "watch", "youtube" };
            foreach (var block in testblock)
            {
                for (int i = 0; i < testname.Length; ++i)
                {
                    string currentPath = path + block + testname[i];
                    Console.WriteLine("work with: " + currentPath);
                    Parser notePars = new Parser(currentPath, tests);
                    notePars.DoParse(predicate[i]);
                    notePars.WriteData("readyData.txt");
                    Directory.SetCurrentDirectory(path + "\\Parsed");
                    string output = block.Split('\\')[1] + "_" + predicate[i] + "_readyData.txt";
                    Console.WriteLine("output: " + output);
                    notePars.WriteData(output);
                }
            }
            Console.WriteLine("-----all done-----");
        }
        static void Main(string[] args)
        {
            //

            //EXAMPLE OF INPUT:
            //D:\course_work\Results
            //25
            Console.Write("for huge test type 'huge', or any other keys for fast test: ");
            string choice = Console.ReadLine();

            if (choice == "huge")
                HugeTest();
            else
                FastTest();
            //
            Console.ReadKey();
        }
    }
}
