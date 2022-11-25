package options;

class ControlsSubState extends MusicBeatSubstate 
{
    public function new() 
    {
        super();
    }

    override function update(e:Float)
    {
        super.update(e);

        if (controls.BACK)
        {
            close ();
        }
    }
}