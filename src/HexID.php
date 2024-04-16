<?php

namespace Mattifesto\HexID;



final class HexID
{
    /**
     * @return string
     */
    public static function generateRandom(Size $size): string
    {
        $bytes = random_bytes($size->value);

        return bin2hex($bytes);
    }
}
