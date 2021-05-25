using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System;
using System.IO;

namespace parserDataTest
{
    public class Parser
    {
        public DataContainer[,,] dataSet;
        public double[] testTimes;
        public string path;
        private int count;
        private int cpus;
        private int states;
        private string padder;
        public Parser(string myPath, int tests)
        {
            path = myPath;
            count = tests;
            cpus = 6;
            states = 2;
            padder = "\t\t";
            testTimes = new double[count];
            dataSet = new DataContainer[cpus, states, count]; //cpu, states, count tests
            
            for (int c = 0; c < cpus; ++c)
                for (int s = 0; s < states; ++s)
                    for (int t = 0; t < count; ++t)
                        dataSet[c, s, t] = new DataContainer();
        }
        public Parser(string myPath, int tests, int cpu, int state, string padding)
        {
            path = myPath;
            count = tests;
            cpus = cpu;
            states = state;
            padder = padding;
            testTimes = new double[count];
            dataSet = new DataContainer[cpus, states, count]; //cpu, states, count tests
            
            for (int c = 0; c < cpus; ++c)
                for (int s = 0; s < states; ++s)
                    for (int t = 0; t < count; ++t)
                        dataSet[c, s, t] = new DataContainer();
        }
        public void DoParse(string filename)//example of filename: note
        {
            Directory.SetCurrentDirectory(path);
            for (int i = 1; i <= count; ++i )
            {
                GetDataFromFileAfter(i.ToString() + filename, i);
                GetDataFromFileBefore(i.ToString() + filename, i);
            }
        }
        //public void WriteData(string filename)
        //{
        //    using (StreamWriter outputFile = new StreamWriter(filename))
        //    {
        //        outputFile.WriteLine("usage -----------  time");
        //        for (int c = 0; c < cpus; ++c)
        //        {
        //            outputFile.WriteLine($"cpu {c}");
        //            for (int s = 0; s < states; ++s)
        //            {
        //                outputFile.WriteLine($"state {s}");
        //                for (int t = 0; t < count; ++t)
        //                {
        //                    outputFile.WriteLine($"{dataSet[c, s, t].usage}\t{dataSet[c, s, t].time}");
        //                }
        //            }
        //        }
        //    }
        //}

        public void WriteData(string filename)
        {
            using (StreamWriter outputFile = new StreamWriter(filename))
            {
                outputFile.WriteLine("\tcpu0\t\t\tcpu1\t...");
                outputFile.WriteLine("state0\t\tstate1\t\t...");
                outputFile.WriteLine("usage\ttime\tusage\ttime\t...");
                for (int t = 0; t < count; ++t)
                {
                    string strout = "";
                    for (int c = 0; c < cpus; ++c)
                    {
                        for (int s = 0; s < states; ++s)
                        {
                            if ((c != 0) || (s != 0))
                                strout += "\t";

                            strout += $"{dataSet[c, s, t].usage}\t{dataSet[c, s, t].time}";
                            //outputFile.WriteLine($"{dataSet[c, s, t].usage}\t{dataSet[c, s, t].time}");
                            //outputFile.WriteLine($"{dataSet[c, s, t].usage}\t{dataSet[c, s, t].time}");
                        }

                        if (c != cpus - 1)
                            strout += padder;
                    }

                    strout += $"\t{testTimes[t]}";
                    outputFile.WriteLine(strout);
                }
            }
        }

        private void GetDataFromFileBefore(string filename, int testNumber)//exampe of filename: 2note
        {
            testNumber -= 1;
            filename = filename + "_before.txt";
            string[] lines = File.ReadAllLines(filename);
            for (int i = 0; i < lines.Length; ++i)
            {
                string[] words = lines[i].Split(' ');
                if (words[0] == "cpu")
                {
                    int cpu = Int32.Parse(words[1]);
                    int state = Int32.Parse(words[3]);
                    //dataSet[cpu, state, testNumber].name = lines[i + 1];
                    //dataSet[cpu, state, testNumber].desc = lines[i + 2];
                    //dataSet[cpu, state, testNumber].disable = Int32.Parse(lines[i + 3]);
                    //dataSet[cpu, state, testNumber].latency = Int32.Parse(lines[i + 4]);
                    //dataSet[cpu, state, testNumber].power = Convert.ToUInt64(lines[i + 5]);
                    //dataSet[cpu, state, testNumber].residency = Int32.Parse(lines[i + 6]);
                    dataSet[cpu, state, testNumber].usage -= Convert.ToUInt64(lines[i + 7]);
                    dataSet[cpu, state, testNumber].time -= Convert.ToUInt64(lines[i + 8]);
                    i = i + 8;
                }
            }
        }

        private void GetDataFromFileAfter(string filename, int testNumber)
        {
            testNumber -= 1;
            string fileTime = filename + "_time.txt";
            filename = filename + "_after.txt";
            string[] lines = File.ReadAllLines(filename);

            for (int i = 0; i < lines.Length; ++i)
            {
                string[] words = lines[i].Split(' ');
                if (words[0] == "cpu")
                {
                    int cpu = Int32.Parse(words[1]);
                    int state = Int32.Parse(words[3]);
                    dataSet[cpu, state, testNumber].name = lines[i + 1];
                    dataSet[cpu, state, testNumber].desc = lines[i + 2];
                    dataSet[cpu, state, testNumber].disable = Int32.Parse(lines[i + 3]);
                    dataSet[cpu, state, testNumber].latency = Int32.Parse(lines[i + 4]);
                    dataSet[cpu, state, testNumber].power = Convert.ToUInt64(lines[i + 5]);
                    dataSet[cpu, state, testNumber].residency = Int32.Parse(lines[i + 6]);
                    dataSet[cpu, state, testNumber].usage = Convert.ToUInt64(lines[i + 7]);
                    dataSet[cpu, state, testNumber].time = Convert.ToUInt64(lines[i + 8]);
                    i = i + 8;
                }
            }
            try
            {
                lines = File.ReadAllLines(fileTime);
                //13:13:12,20 
                string[] times = lines[1].Split(':');
                double timeFirst = (double)(Int32.Parse(times[2].Split(',')[1])) / 100 + Int32.Parse(times[2].Split(',')[0]) + Int32.Parse(times[1]) * 60 + Int32.Parse(times[0]) * 60 * 60;
                times = lines[0].Split(':');
                timeFirst -= (Int32.Parse(times[0]) * 60 * 60 + Int32.Parse(times[1]) * 60 + Int32.Parse(times[2].Split(',')[0]) + (double)(Int32.Parse(times[2].Split(',')[1])) / 100);
                testTimes[testNumber] = timeFirst * 1000000;
            }
            catch (Exception)
            {
                testTimes[testNumber] = 0;
            }
        }
    }
}
