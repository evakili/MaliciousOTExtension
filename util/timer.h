/*
 * timer.h
 *
 *  Created on: Apr 5, 2014
 *      Author: mzohner
 */

#ifndef __TIMER_H__
#define __TIMER_H__

#include <sys/time.h>
#include <string>
#include <iostream>
#include <stdlib.h>
#include "typedefs.h"

//Note do not change P_FIRST and P_LAST and keep them pointing to the first and last element in the enum
enum ABYPHASE {P_TOTAL, P_INIT, P_CIRCUIT, P_NETWORK, P_BASE_OT, P_SETUP, P_OT_EXT, P_GARBLE, P_ONLINE, P_FIRST=P_TOTAL, P_LAST=P_ONLINE};
struct aby_timings {
	double timing;
	timeval tbegin;
	timeval tend;
};

static int m_nTimings = P_LAST-P_FIRST+1;
static aby_timings m_tTimes[P_LAST-P_FIRST+1];
using namespace std;


// Timing routines
static double getMillies(timeval timestart, timeval timeend)
{
	long time1 = (timestart.tv_sec * 1000000) + (timestart.tv_usec );
	long time2 = (timeend.tv_sec * 1000000) + (timeend.tv_usec );

	return (double)(time2-time1)/1000;
}

/*static void InitClock() {
	//m_nTimings = P_LAST - P_FIRST + 1;
//	m_tTimes = (aby_timings*) calloc(m_nTimings, sizeof(aby_timings));
}*/

static void StartWatch(const string& msg, ABYPHASE phase) {
	if (phase < P_FIRST && phase > P_LAST) {
			cerr << "Phase not recognized: " << phase << endl;
			return;
	}
	//cout << " m_nTimings, " << m_nTimings <<  ", phase = " << (unsigned int) phase << endl;
	gettimeofday(&(m_tTimes[phase].tbegin), NULL);
#ifndef BATCH
	cout << msg << endl;
#endif
}

static void StopWatch(const string& msg, ABYPHASE phase) {
	if (phase < P_FIRST && phase > P_LAST) {
			cerr << "Phase not recognized: " << phase << endl;
			return;
	} /*else	if(m_tTimes[phase].tbegin == 0) {
		cerr << "Timer not started for phase " << phase << endl;
		return;
	}*/

	gettimeofday(&(m_tTimes[phase].tend), NULL);
	m_tTimes[phase].timing = getMillies(m_tTimes[phase].tbegin, m_tTimes[phase].tend);


#ifndef BATCH
	cout << msg << m_tTimes[phase].timing << " ms " << endl;
#endif

}
//enum ABYPHASE {P_TOTAL, P_INIT, P_CIRCUIT, P_NETWORK, P_SETUP, P_BASE_OT, P_OT_EXT, P_ONLINE, P_FIRST=P_TOTAL, P_LAST=P_ONLINE};

static void PrintTimings() {
	string unit = " ms";
	cout << "Timings: " << endl;
	cout << "Total =\t\t" << m_tTimes[0].timing << unit << endl;
	cout << "Init =\t\t" << m_tTimes[1].timing << unit << endl;
	cout << "CircuitGen =\t" << m_tTimes[2].timing << unit << endl;
	cout << "Network =\t" << m_tTimes[3].timing << unit << endl;
	cout << "BaseOTs =\t" << m_tTimes[4].timing << unit << endl;
	cout << "Setup =\t\t" << m_tTimes[5].timing << unit << endl;
	cout << "OTExtension =\t" << m_tTimes[6].timing << unit << endl;
	cout << "Garbling =\t" << m_tTimes[7].timing << unit << endl;
	cout << "Online =\t" << m_tTimes[8].timing << unit << endl;
}

static double GetTimeForPhase(ABYPHASE phase) {
	return m_tTimes[phase].timing;
}



#endif /* TIMER_H_ */
