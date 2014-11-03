import java.security.SecureRandom;

import edu.biu.scapi.comm.Channel;
import edu.biu.scapi.interactiveMidProtocols.ot.otBatch.OTBatchRInput;
import edu.biu.scapi.interactiveMidProtocols.ot.otBatch.OTBatchROutput;
import edu.biu.scapi.interactiveMidProtocols.ot.otBatch.otExtension.OTExtensionGeneralRInput;
import edu.biu.scapi.interactiveMidProtocols.ot.otBatch.otExtension.OTExtensionMaliciousReceiver;


public class ReceiverMain {
	public static void main(String[] args) {
		int m = 700;
		OTExtensionMaliciousReceiver receiver = new OTExtensionMaliciousReceiver("127.0.0.1", 7766, m);
		SecureRandom random = new SecureRandom();
		
		byte[] sigmaArr = new byte[m];
		for (int i = 0; i < sigmaArr.length; i++) {
			sigmaArr[i] = (byte) random.nextInt(2);
		}
		
		int elementSize = 128; // size of each received "x", in bits.
		Channel channel = null;
		
		OTBatchRInput input = new OTExtensionGeneralRInput(sigmaArr, elementSize);
		OTBatchROutput out = receiver.transfer(channel, input);
		System.out.println(out);
	}
}
