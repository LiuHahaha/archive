import java.util.*;

public class Simulation
{
    public static void main(String[] args)
    {
        double lambda = Double.parseDouble(args[0]);
        double mean = 0;
        for(int i = 0; i < 2000; i++)
            mean += trial(lambda);
        System.out.println(mean/2000);
    }
    private static double trial(Double lambda)
    {
        //qLoad is the total work in the queue immediately after adding the ith element
        double qLoad = 0;
        for(int i = 0; i < 2001; i++)
            qLoad = expDist(1) + Math.max(qLoad - expDist(lambda), 0);
        return qLoad;
    }
    private static double expDist(double lambda)
    {
        double u = new Random().nextDouble();
        return -((Math.log(1 - u))/lambda);
    }
}
