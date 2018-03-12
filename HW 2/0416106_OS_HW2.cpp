#include<iostream>
#include<queue>
#include<iterator>
#include<fstream>
#include<vector>
using namespace std;

//Declaring class to maintain process data
class Process
{
    public:
        Process()
        {
            pid = 0; arrival = 0; burst1 = 0; context_switch = 0; burst2 = 0;
        }
        friend istream& operator >> (istream &input, Process &process)
        {
            input >> process.pid;
            input >> process.arrival;
            input >> process.burst1;
            input >> process.context_switch;
            input >> process.burst2;
            return input;
        }
        int pid;
        int arrival;
        int burst1;
        int context_switch;
        int burst2;
};

//Comparison class to make arrival sorted so that top() always smallest
class arrival_compare
{
    public:
        bool operator() (const Process &a, const Process &b)
        {
            return a.arrival > b.arrival;
        }
};

//Comparison class for SJF and SRTF for process that to be chosen first
class burst_compare
{
    public:
        bool operator() (const Process &a, const Process &b)
        {
            if(a.burst1 > b.burst1) return true;
            else if(a.burst1 == b.burst1)
                if(a.arrival > b.arrival) return true;
                else if(a.arrival == b.arrival)
                    if(a.pid > b.pid) return true;
            return false;
        }
};

void SJF(ifstream& infile, ofstream& outfile)
{
    int number_process;
    infile >> number_process;
    //Vector to fit in process
    priority_queue<Process, vector<Process>, arrival_compare> arriving;
    priority_queue<Process, vector<Process>, burst_compare> chart;
    vector<Process> io_wait;

    //Pushing data into the arriving vector
    while(number_process--)
    {
        Process temp;
        infile >> temp;
        arriving.push(temp);
    }

    //Declaring process variable to determine ongoing process
    Process ongoing;
    //Determine if new process can or cannot be assigned to ongoing
    bool lock = false;
    //Time unit
    int time;
    //Time increasing slowly by 1 unit of time
    for( time = 0; (!chart.empty() || !io_wait.empty() || !arriving.empty()); ++time)
    {
        //Pushing process that has arrived
        while(!arriving.empty())
        {
            Process temporary = arriving.top();
            if(temporary.arrival <= time)
            {
                chart.push(temporary);
                arriving.pop();
            }
            else break;
        }

        //Decreasing IO availability by time
        for(vector<Process>::iterator it = io_wait.begin(); it < io_wait.end(); ++it)
        {
            //Decreasing IO time
            --it->context_switch;
            //If IO time has finished
            if(it->context_switch == 0)
            {
                //New arrival time value back to chart vector
                it->arrival = time + 1;
                arriving.push(*it);
                io_wait.erase(it);
                if(!io_wait.empty()) --it;
            }
        }

        //If the ongoing process before has finished
        if(!lock && !chart.empty())
        {
            //Another process cannot preempt ongoing process
            lock = true;
            //Taking highest priority process
            ongoing = chart.top();
            chart.pop();
        }
        else if(!lock) ongoing = Process();
        //Decreasing burst time
        --ongoing.burst1;

        //If the first and second burst has ended
        if( ongoing.burst1 == 0 && ongoing.burst2 == 0)
        {
            //The process has been completed
            outfile << ongoing.pid << ":" << time+1 << endl;
            //Let new process get in ongoing
            lock = false;
        }
        //If the first burst has ended
        else if (ongoing.burst1 == 0)
        {
            //Let new process get in ongoing
            lock = false;
            ongoing.burst1 = ongoing.burst2;
            ongoing.burst2 = 0;
            io_wait.push_back(ongoing);
        }

    }
    //Print the only remaining process
    if(ongoing.burst1 != 0 || ongoing.context_switch != 0 || ongoing.burst2 != 0)
        outfile << ongoing.pid << ":" << time+ongoing.burst1+ongoing.context_switch+ongoing.burst2 << endl;

    return;
}

void SRTF(ifstream& infile, ofstream& outfile)
{
    int number_process;
    infile >> number_process;
    //Vector to fit in process
    priority_queue<Process, vector<Process>, arrival_compare> arriving;
    priority_queue<Process, vector<Process>, burst_compare> chart;
    vector<Process> io_wait;

    //Pushing data into the arriving vector
    while(number_process--)
    {
        Process temp;
        infile >> temp;
        arriving.push(temp);
    }

    //Declaring process variable to determine ongoing process
    Process ongoing;
    //Time unit
    int time;
    //Time increasing slowly by 1 unit of time
    for( time = 0; (!chart.empty() || !io_wait.empty() || !arriving.empty()); ++time)
    {
        //Pushing process that has arrived
        while(!arriving.empty())
        {
            Process temporary = arriving.top();
            if(temporary.arrival <= time)
            {
                chart.push(temporary);
                arriving.pop();
            }
            else break;
        }

        //Decreasing IO availability by time
        for(vector<Process>::iterator it = io_wait.begin(); it < io_wait.end(); ++it)
        {
            //Decreasing IO time
            --it->context_switch;
            //If IO time has finished
            if(it->context_switch == 0)
            {
                //New arrival time value back to chart vector
                it->arrival = time + 1;
                arriving.push(*it);
                io_wait.erase(it);
                if(!io_wait.empty()) --it;
            }
        }

        //Taking highest priority process
        ongoing = chart.top();
        chart.pop();

        //Decreasing burst time
        --ongoing.burst1;

        //If the first and second burst has ended
        if( ongoing.burst1 == 0 && ongoing.burst2 == 0 )
        {
            //The process has been completed
            outfile << ongoing.pid << ":" << time+1 << endl;
        }
        //If the first burst has ended
        else if (ongoing.burst1 == 0)
        {
            ongoing.burst1 = ongoing.burst2;
            ongoing.burst2 = 0;
            io_wait.push_back(ongoing);
        }
        //Put the ongoing process back to queue to be sorted again
        else chart.push(ongoing);

    }

    return;
}

void MLQF(ifstream& infile, ofstream& outfile)
{
    int number_process;
    infile >> number_process;
    //Vector to fit in process
    priority_queue<Process, vector<Process>, arrival_compare> arriving;
    queue<Process> rr_chart, fcfs_chart;
    vector<Process> rr_io_wait, fcfs_io_wait;

    //Pushing data into the arriving vector
    while(number_process--)
    {
        Process temp;
        infile >> temp;
        arriving.push(temp);
    }

    //Declaring process variable to determine ongoing process
    enum{rr, fcfs};
    int on_status = rr;
    Process ongoing;
    //Determine if new process can or cannot be assigned to ongoing
    bool lock = false;
    //Time unit
    int time, quantum_time;
    //Time increasing slowly by 1 unit of time
    for( time = 0, quantum_time = 0; (!fcfs_chart.empty() || !rr_chart.empty() || !fcfs_io_wait.empty() || !rr_io_wait.empty() || !arriving.empty()); ++time, ++quantum_time)
    {
        //If fcfs, then time quantum is not needed
        if(on_status == fcfs) quantum_time = 0;

        //Pushing process that has arrived
        while(!arriving.empty())
        {
            Process temporary = arriving.top();
            if(temporary.arrival <= time)
            {
                rr_chart.push(temporary);
                arriving.pop();
            }
            else break;
        }

        //Pushing IO that has already finished
        for(vector<Process>::iterator it = rr_io_wait.begin(); it < rr_io_wait.end(); ++it)
        {
            //If IO time has finished
            if(it->context_switch == 0)
            {
                //New arrival time value back to chart vector
                it->arrival = time;
                rr_chart.push(*it);
                rr_io_wait.erase(it);
                if(!rr_io_wait.empty()) --it;
            }
        }
        for(vector<Process>::iterator it = fcfs_io_wait.begin(); it < fcfs_io_wait.end(); ++it)
        {
            //If IO time has finished
            if(it->context_switch == 0)
            {
                //New arrival time value back to chart vector
                it->arrival = time ;
                fcfs_chart.push(*it);
                fcfs_io_wait.erase(it);
                if(!fcfs_io_wait.empty()) --it;
            }
        }

        //Put the ongoing process back to queue to be queued again
        if(on_status == rr && quantum_time == 4)
        {
            //Let other process to get in ongoing
            lock = false;
            //Reset quantum time
            quantum_time = 0;
            //Push all process that have not finish in 4 time unit to fcfs queue
            ongoing.arrival = time + 1;
            fcfs_chart.push(ongoing);
        }

        //Decreasing IO availability by time for rr_io_wait
        for(vector<Process>::iterator it = rr_io_wait.begin(); it < rr_io_wait.end(); ++it) --it->context_switch;

        //Decreasing IO availability by time fcfs_io_wait
        for(vector<Process>::iterator it = fcfs_io_wait.begin(); it < fcfs_io_wait.end(); ++it) --it->context_switch;

        //If there are higher priority process that could preempt ongoing process
        if(on_status == fcfs && !rr_chart.empty())
        {
            //Quantum time
            quantum_time = 0;
            //Status
            on_status = rr;
            //Another process cannot preempt ongoing process
            lock = true;
            //Push back the fcfs ongoing process
            ongoing.arrival = time + 1;
            fcfs_chart.push(ongoing);
            //Taking highest priority process
            ongoing = rr_chart.front();
            rr_chart.pop();
        }
        //If the ongoing process before has finished
        else if(!lock && !rr_chart.empty())
        {
            //Quantum time
            quantum_time = 0;
            //Status
            on_status = rr;
            //Another process cannot preempt ongoing process
            lock = true;
            //Taking highest priority process
            ongoing = rr_chart.front();
            rr_chart.pop();
        }
        else if(!lock && !fcfs_chart.empty())
        {
            //Status
            on_status = fcfs;
            //Another proces cannot preempt ongoing process except for the one in rr queue
            lock = true;
            //Taking highest prority process
            ongoing = fcfs_chart.front();
            fcfs_chart.pop();
        }
        //If nothing is ongoing, quantum time retains it value zero
        else if(!lock)
        {
            //Status
            on_status = rr;
            //Quantum time
            quantum_time = 0;
            ongoing = Process();
        }
        //Decreasing burst time
        --ongoing.burst1;

        //If the first and second burst has ended
        if( ongoing.burst1 == 0 && ongoing.burst2 == 0 )
        {
            //status
            on_status = rr;
            //The process has been completed
            outfile << ongoing.pid << ":" << time+1 << endl;
            //Let new process in the ongoing
            lock = false;
            //Quantum time is reseted
            quantum_time = 0;
        }
        //If the first burst has ended
        else if (ongoing.burst1 == 0)
        {
            //Let new process in the ongoing
            lock = false;
            //Reset quantum time
            quantum_time = 0;
            //Push it into IO queue
            ongoing.burst1 = ongoing.burst2;
            ongoing.burst2 = 0;
            if(on_status == rr) rr_io_wait.push_back(ongoing);
            else fcfs_io_wait.push_back(ongoing);
            //Status
            on_status = rr;
        }

    }
    //Print the only remaining process
    if(ongoing.burst1 != 0 || ongoing.context_switch != 0 || ongoing.burst2 != 0)
        outfile << ongoing.pid << ":" << time+ongoing.burst1+ongoing.context_switch+ongoing.burst2 << endl;

    return;
}

int main(int argc, char *argv[])
{
    //Opening file
    ifstream infile;
    ofstream outfile;
    infile.open("input.txt");
    if(!infile.is_open())
    {
        cerr << "Error opening input file";
        return 1;
    }
    outfile.open("0416106.txt");

    int quest_type;
    infile >> quest_type;

    //Determining the question to be answered
    if( quest_type == 1 ) SJF(infile, outfile);
    else if( quest_type == 2 ) SRTF(infile, outfile);
    else if( quest_type == 3 ) MLQF(infile, outfile);
    else cerr << "No such comment can be processed\n";

    //Closing file
    infile.close();
    outfile.close();

    return 0;
}
