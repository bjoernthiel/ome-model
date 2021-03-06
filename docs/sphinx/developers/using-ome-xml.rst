Using OME-XML schema elements
=============================

This sections explains how to use OME schema elements in your own XML files.

.. note:: 
    The correct attribution for work derived from our schema files under the 
    Creative Commons licence is:
    **"This work is derived in part from the OME specification.
    Copyright (C) 2002-2017 Open Microscopy Environment"**

We encourage people to make use of the OME Data Model as a
whole by using the OME-XML and OME-TIFF formats directly. If you need to
store additional user-specific data, the correct approach is to embed it
within the OME Data Model using Structured Annotations. These provide a
powerful and flexible way of storing your own custom data alongside the
OME model metadata, while still maintaining full compatibility with OME-XML 
and OME-TIFF files, ensuring your file can be read by any application 
supporting these formats.

If this approach will not work for you, we would encourage you to
contact us via the :forum:`forums <>` and :mailinglist:`mailing lists <>` as 
we may be able to help you structure your additions so compatibility can be 
maintained. Fully compatible and exchangeable files is what this project all 
is about, so we try to support this as much as we can.

If there is still no possible approach for your data that can maintain
compatibility with OME-XML or OME-TIFF, then what follows is the best
practice for this situation.

Things to avoid
---------------

#. Adding arbitrary items to the OME Model and still calling it OME-XML
   or OME-TIFF

   We cannot stress enough that this is a **very bad** approach! If you
   simply insert your own custom nodes at arbitrary points within the
   XML document, you will produce a broken/invalid OME-XML or OME-TIFF
   file. As the outer wrapping looks like an OME file, people will
   expect it to work like an OME file. Applications are likely to fail to 
   import the file as they will produce an error as they
   encounter your additional XML elements. This will frustrate end users
   and is likely to produce reports of broken applications. These tend
   to ultimately propagate back to our development team and we have to
   investigate, which eats into the time we have available to work on
   new features and formats.

#. Adding or removing arbitrary items to/from the OME Model by copying
   our structure and calling it something else

   This is also **not** a good approach. If you copy the OME Model and
   then make changes (whether by deletion or addition) you are also
   producing a broken/invalid file, even if you call it something else.
   We have defined parts of the model that can be omitted (marked as
   optional in the schema), and defined points where additions can be
   made (inside the Structured Annotations). It is important to us that
   we have some control over additions and omissions as it allows us to
   produce a format that has the widest compatibility. Even though the
   specifications we produce are now released under a less
   restrictive license, we do not encourage this approach. We want anyone
   who encounters an OME node in an XML document to be able to trust
   its structure, as well as validate and parse it.

#. A 'pick and mix' by copying our structure

   While we have changed the licence the schema files for the OME Model
   are released under to allow this approach, we would not encourage
   this. You should **not** need to copy pieces of our definitions and
   place them directly in your schema documents.

   Direct copying of our structure is not necessary as XML already has a
   method of including items from another schema, **see below**. From
   our point of view this is important as it allows us to control which
   parts of our model can be used as stand-alone objects in others' work.

Correct approaches
------------------

If you have to define your own schema that will make use of our OME
model, there are two approaches:

#. Wrapping our entire OME Model in your custom model

   The entire OME Model, when used in an instance document, is
   completely contained inside the ``<OME>`` node. It is possible to
   include a complete ``<OME>`` node from the OME schema within your own
   custom XML node. While this does not maintain direct compatibility
   with the OME-XML and OME-TIFF file formats, it keeps all of the OME
   Model data together as a single block, that can be easily extracted
   from your custom XML nodes and passed to a standard OME-XML parser
   for it to interpret. It only takes a single line of XML Schema
   Description Language to include the whole model like this.

   We would always see this wrapping of the **entire OME model** as the
   best approach to take if you have to define your own custom model. It
   is also the best way of future-proofing yourself, as an ``<OME>`` node
   included like this will be easier to upgrade to newer schema
   releases using our standard transform.

#. A 'pick and mix' by referencing parts of our structure

   The least desirable valid approach is to individually include small
   independent parts of the model. Any of the items defined at the top
   level of the OME schema may be included individually within your
   custom model. If you take this approach, you must understand that
   including a node also includes those nodes below it, i.e. including
   LightSource also includes Laser, Arc etc. This approach does let
   you select individual parts of our OME model to include, but also
   lets us control which parts of the model are available for inclusion.
   Any reading/writing code for OME model pieces stored in this form
   will have to be custom written, as standard OME model parsers will not
   be able to process the pieces.

.. note:: 
    With either of these approaches please acknowledge our work by
    including in the appropriate place in your software or project
    documentation:
    **"This work is derived in part from the OME specification.
    Copyright (C) 2002-2017 Open Microscopy Environment"**

Worked examples
---------------

Here are a few examples of how to define a link to the OME model from
within your custom schema file and instance documents.

sample-third-party.xml
''''''''''''''''''''''

This is an instance document - the xml file that
contains your data and is structured to conform to your custom
schema specification:

::

    <?xml version="1.0" encoding="UTF-8"?>
    <CustomTag
        xmlns="http://www.example.org/SampleThirdPartySchema/2013-01"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.example.org/SampleThirdPartySchema/2013-01
            file:sample-third-party.xsd">

        <YourNodes>
            <With your="attributes"/>
        </YourNodes>

        <!-- Insert an OME node from the 2016-06 version of our schema -->
        <OME xmlns="http://www.openmicroscopy.org/Schemas/OME/2016-06"
            xsi:schemaLocation="http://www.openmicroscopy.org/Schemas/OME/2016-06
                                http://www.openmicroscopy.org/Schemas/OME/2016-06/ome.xsd"
            >
            <Image ID="Image:1">
                <AcquisitionDate>2010-02-23T12:51:30</AcquisitionDate>
                <Pixels ID="Pixels:1" DimensionOrder="XYZCT" Type="uint8" SizeX="1" SizeY="1" SizeZ="1"
                    SizeT="1" SizeC="1">
                    <MetadataOnly/>
                </Pixels>
            </Image>
        </OME>
        <!-- Finish the OME node, and continue with your custom schema -->

        <MoreOfYourNodes></MoreOfYourNodes>
    </CustomTag>

This file has ``<YourNodes>`` followed by the ``<OME>`` node, then
``<MoreOfYourNodes>``. Apart from the xml namespace and schema location
attributes on the ``<OME>`` node, the file is the same as though the OME
model was part of your custom namespace.


sample-third-party.xsd
''''''''''''''''''''''

In order to define the easy-to-use structure described in the
sample-third-party.xml file, you need to add 
three things (marked ``****``) to your schema specification document:

::

    <?xml version="1.0" encoding="UTF-8"?>

    <!-- **** Define the OME namespace for your schema on the <schema> node **** -->
    <xs:schema 
        xmlns:OME="http://www.openmicroscopy.org/Schemas/OME/2016-06"

        xmlns="http://www.example.org/SampleThirdPartySchema/2013-01" 
        targetNamespace="http://www.example.org/SampleThirdPartySchema/2013-01" 
        xmlns:xs="http://www.w3.org/2001/XMLSchema" 
        version="1" 
        elementFormDefault="qualified">

        <!-- **** Include the OME namespace to make it accessible from your schema **** -->
        <xs:import namespace="http://www.openmicroscopy.org/Schemas/OME/2016-06"
        schemaLocation="http://www.openmicroscopy.org/Schemas/OME/2016-06/ome.xsd"/>

        <xs:element name="CustomTag">
            <xs:annotation>
                <xs:documentation>
                    Open Microscopy Environment
                    OME Sample Third Party
                    Copyright 2016 OME.
                </xs:documentation>
            </xs:annotation>
            <xs:complexType>
                <xs:sequence>
                    <xs:element name="YourNodes">
                        <xs:complexType>
                            <xs:sequence>
                                <xs:element name="With">
                                    <xs:complexType>
                                        <xs:attribute name="your" use="required" type="xs:string"/>
                                    </xs:complexType>
                                </xs:element>
                            </xs:sequence>
                        </xs:complexType>
                    </xs:element>

                    <!-- **** Reference to the OME element **** -->
                    <xs:element ref="OME:OME" minOccurs="1" maxOccurs="1"/>

                    <xs:element name="MoreOfYourNodes"/>
                </xs:sequence>
            </xs:complexType>
        </xs:element>
    </xs:schema>


sample-third-party-pieces.xml
'''''''''''''''''''''''''''''

If you want to import only a few pieces of the OME Model, this 
example illustrates how to include ``<LightSource>`` and ``<Objective>``:


::

    <?xml version="1.0" encoding="UTF-8"?>
    <CustomTag
        xmlns="http://www.example.org/SampleThirdPartySchemaPieces/2013-01"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.example.org/SampleThirdPartySchemaPieces/2013-01
            file:sample-third-party-pieces.xsd">

        <YourNodes>
            <With your="attributes"/>
        </YourNodes>

        <!-- Insert a LightSource node from the 2016-06 version of our schema -->
        <Laser xmlns="http://www.openmicroscopy.org/Schemas/OME/2016-06"
               xsi:schemaLocation="http://www.openmicroscopy.org/Schemas/OME/2016-06
                 http://www.openmicroscopy.org/Schemas/OME/2016-06/ome.xsd"
            ID="LightSource:1" Type="Dye" FrequencyMultiplication="2"
            LaserMedium="CoumarinC30" PockelCell="true" Pulse="Single"
            RepetitionRate="1.3" Tuneable="true" Wavelength="640">
          <Pump ID="LightSource:4"/>
        </Laser>
        <!-- Finish the LightSource node, and continue with your custom schema -->

        <MoreOfYourNodes>

            <!-- Insert an Objective node from the 2016-06 version of our schema -->
            <Objective xmlns="http://www.openmicroscopy.org/Schemas/OME/2016-06"
                xsi:schemaLocation="http://www.openmicroscopy.org/Schemas/OME/2016-06
                     http://www.openmicroscopy.org/Schemas/OME/2016-06/ome.xsd"
                ID="Objective:1" CalibratedMagnification="0.3" Correction="UV" 
                Immersion="Air" Iris="true" LensNA="1.3" NominalMagnification="2"
                WorkingDistance="2.3" Manufacturer="OME-Sample" Model="Mk II"
                SerialNumber="sn-234567"/>  
            <!-- Finish the Objective node, and continue with your custom schema -->

            <EvenMoreOfYourNodes></EvenMoreOfYourNodes>
        </MoreOfYourNodes>
    </CustomTag>


sample-third-party-pieces.xsd
'''''''''''''''''''''''''''''

In order to define this sample-third-party-pieces.xml structure, you need to
add four lines (marked ``****``) to your schema specification document. The
first two lines are the same as the previous schema specification, then add
one line for each of the two included nodes:

::

    <?xml version="1.0" encoding="UTF-8"?>

    <!-- **** Define the OME namespace for your schema on the <schema> node **** -->
    <xs:schema 
        xmlns:OME="http://www.openmicroscopy.org/Schemas/OME/2016-06"

        xmlns="http://www.example.org/SampleThirdPartySchemaPieces/2013-01" 
        targetNamespace="http://www.example.org/SampleThirdPartySchemaPieces/2013-01" 
        xmlns:xs="http://www.w3.org/2001/XMLSchema" 
        version="1" 
        elementFormDefault="qualified">

        <!-- **** Include the OME namespace to make it accessible from your schema **** -->
        <xs:import namespace="http://www.openmicroscopy.org/Schemas/OME/2016-06"
        schemaLocation="http://www.openmicroscopy.org/Schemas/OME/2016-06/ome.xsd"/>

        <xs:element name="CustomTag">
            <xs:annotation>
                <xs:documentation>
                    Open Microscopy Environment
                    OME Sample Third Party
                    Copyright 2016 OME.
                </xs:documentation>
            </xs:annotation>
            <xs:complexType>
                <xs:sequence>
                    <xs:element name="YourNodes">
                        <xs:complexType>
                            <xs:sequence>
                                <xs:element name="With">
                                    <xs:complexType>
                                        <xs:attribute name="your" use="required" type="xs:string"/>
                                    </xs:complexType>
                                </xs:element>
                            </xs:sequence>
                        </xs:complexType>
                    </xs:element>

                    <!-- **** Reference to the LightSource element **** -->
                    <xs:element ref="OME:LightSource" minOccurs="1" maxOccurs="1"/>

                    <xs:element name="MoreOfYourNodes">
                        <xs:complexType>
                            <xs:sequence>

                                <!-- **** Reference to the Objective element **** -->
                                <xs:element ref="OME:Objective" minOccurs="1" maxOccurs="1"/>

                                <xs:element name="EvenMoreOfYourNodes"/>
                            </xs:sequence>
                        </xs:complexType>
                    </xs:element>
                </xs:sequence>
            </xs:complexType>
        </xs:element>
    </xs:schema>

Possible included objects
'''''''''''''''''''''''''

.. hlist::
    :columns: 2

    - ``<xs:element ref="AnnotationRef">``
    - ``<xs:element ref="Arc">``
    - ``<xs:element ref="BinaryFile">``
    - ``<xs:element ref="BinData">``
    - ``<xs:element ref="BooleanAnnotation">``
    - ``<xs:element ref="Channel">``
    - ``<xs:element ref="ChannelRef">``
    - ``<xs:element ref="CommentAnnotation">``
    - ``<xs:element ref="Dataset">``
    - ``<xs:element ref="DatasetRef">``
    - ``<xs:element ref="Detector">``
    - ``<xs:element ref="DetectorSettings">``
    - ``<xs:element ref="Dichroic">``
    - ``<xs:element ref="DichroicRef">``
    - ``<xs:element ref="DoubleAnnotation">``
    - ``<xs:element ref="Ellipse">``
    - ``<xs:element ref="FilterRef">``
    - ``<xs:element ref="Experiment">``
    - ``<xs:element ref="Experimenter">``
    - ``<xs:element ref="ExperimenterGroup">``
    - ``<xs:element ref="ExperimenterGroupRef">``
    - ``<xs:element ref="ExperimenterRef">``
    - ``<xs:element ref="ExperimentRef">``
    - ``<xs:element ref="External">``
    - ``<xs:element ref="Filament">``
    - ``<xs:element ref="FileAnnotation">``
    - ``<xs:element ref="Filter">``
    - ``<xs:element ref="FilterSet">``
    - ``<xs:element ref="FilterSetRef">``
    - ``<xs:element ref="GenericExcitationSource">``
    - ``<xs:element ref="HashSHA1">``
    - ``<xs:element ref="Image">``
    - ``<xs:element ref="ImageRef">``
    - ``<xs:element ref="ImagingEnvironment">``
    - ``<xs:element ref="Instrument">``
    - ``<xs:element ref="InstrumentRef">``
    - ``<xs:element ref="Label">``
    - ``<xs:element ref="Laser">``
    - ``<xs:element ref="Leader">``
    - ``<xs:element ref="LightEmittingDiode">``
    - ``<xs:element ref="LightPath">``
    - ``<xs:element ref="LightSource">``
    - ``<xs:element ref="LightSourceSettings">``
    - ``<xs:element ref="Line">``
    - ``<xs:element ref="ListAnnotation">``
    - ``<xs:element ref="LongAnnotation">``
    - ``<xs:element ref="M">`` *(part of the Map key/value structure)*
    - ``<xs:element ref="Map">``
    - ``<xs:element ref="MapAnnotation">``
    - ``<xs:element ref="Mask">``
    - ``<xs:element ref="MetadataOnly">``
    - ``<xs:element ref="MicrobeamManipulation">``
    - ``<xs:element ref="MicrobeamManipulationRef">``
    - ``<xs:element ref="Microscope">``
    - ``<xs:element ref="Objective">``
    - ``<xs:element ref="ObjectiveSettings">``
    - ``<xs:element ref="OME">``
    - ``<xs:element ref="Pixels">``
    - ``<xs:element ref="Plane">``
    - ``<xs:element ref="Plate">``
    - ``<xs:element ref="PlateAcquisition">``
    - ``<xs:element ref="PlateRef">``
    - ``<xs:element ref="Point">``
    - ``<xs:element ref="Polygon">``
    - ``<xs:element ref="Polyline">``
    - ``<xs:element ref="Project">``
    - ``<xs:element ref="ProjectRef">``
    - ``<xs:element ref="Pump">``
    - ``<xs:element ref="Reagent">``
    - ``<xs:element ref="ReagentRef">``
    - ``<xs:element ref="Rectangle">``
    - ``<xs:element ref="Rights">``
    - ``<xs:element ref="RightsHeld">``
    - ``<xs:element ref="RightsHolder">``
    - ``<xs:element ref="ROI">``
    - ``<xs:element ref="ROIRef">``
    - ``<xs:element ref="Screen">``
    - ``<xs:element ref="Shape">``
    - ``<xs:element ref="StageLabel">``
    - ``<xs:element ref="StructuredAnnotations">``
    - ``<xs:element ref="TagAnnotation">``
    - ``<xs:element ref="TermAnnotation">``
    - ``<xs:element ref="TiffData">``
    - ``<xs:element ref="TimestampAnnotation">``
    - ``<xs:element ref="TransmittanceRange">``
    - ``<xs:element ref="UUID">``
    - ``<xs:element ref="Well">``
    - ``<xs:element ref="WellSample">``
    - ``<xs:element ref="WellSampleRef">``
    - ``<xs:element ref="XMLAnnotation">``
