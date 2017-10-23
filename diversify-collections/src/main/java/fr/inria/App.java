package fr.inria;

import org.apache.maven.model.Dependency;
import org.apache.maven.model.Model;
import org.apache.maven.model.io.xpp3.MavenXpp3Reader;
import org.apache.maven.model.io.xpp3.MavenXpp3Writer;
import org.codehaus.plexus.util.xml.pull.XmlPullParserException;
import spoon.Launcher;
import spoon.reflect.CtModel;

import java.io.*;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( String[] args )
    {
        if(args.length != 2 && args.length != 3) {
            promptUsage();
            return;
        }

        File srcDir = new File(args[0]);
        File genDir = new File(args[1]);
        System.out.println("Loading: " + srcDir.getPath() + ", output: " + genDir.getPath());

        Launcher launcher = new Launcher();

        launcher.addInputResource(srcDir.getPath());
        //launcher.getEnvironment().setAutoImports(true);
        launcher.getEnvironment().setNoClasspath(true);
        //launcher.getEnvironment().setComplianceLevel(8);
        System.out.println("Building model");
        launcher.buildModel();
        System.out.println("Model built");

        CtModel model = launcher.getModel();
        launcher.setSourceOutputDirectory(genDir.getPath());
        launcher.addProcessor(new SwapCollectionsProcessor());
        launcher.process();
        //launcher.prettyprint();
        try {
            SwapCollectionsProcessor.printJavaFiles(genDir);
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("Generated (transform: " + SwapCollectionsProcessor.nbDivPoint + ", space size: " + SwapCollectionsProcessor.spaceSize + ")");
        if(args.length == 3) {
            File pomDir = new File(args[2]);
            addDependency(pomDir);
        }
        System.out.println("Done");
    }

    private static void promptUsage() {
        System.out.println("App srcDir genDir [pomDir]");
    }

    public static void addDependency(File genDir) {
        try {
            //Reading
            MavenXpp3Reader reader = new MavenXpp3Reader();
            Model model = reader.read(new FileInputStream(new File(genDir, "/pom.xml")));
            //dep.

            Dependency d = new Dependency();
            d.setArtifactId("commons-collections4");
            d.setGroupId("org.apache.commons");
            //d.setType("type");
            //Editing
            d.setVersion("4.1");
            model.addDependency(d);

            //Writing
            MavenXpp3Writer writer = new MavenXpp3Writer();
            writer.write(new FileOutputStream(new File(genDir, "/pom.xml")), model);
        } catch (XmlPullParserException e) {
            e.printStackTrace();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
